package main

import (
	"bufio"
	"encoding/json"
	"fmt"
	"log"
	"os"
	"os/exec"
	"os/user"
	"path/filepath"
	"strings"
	"time"
)

// Config holds the configuration for the dotfiles installation
type Config struct {
	DotfilesRepo string `json:"dotfiles_repo"`
	InstallZsh   bool   `json:"install_zsh"`
	InstallOhMyZsh bool `json:"install_oh_my_zsh"`
	HomeDir      string `json:"home_dir"`
}

// SetupState tracks the installation progress
type SetupState struct {
	DependenciesInstalled bool      `json:"dependencies_installed"`
	ZshInstalled          bool      `json:"zsh_installed"`
	OhMyZshInstalled      bool      `json:"oh_my_zsh_installed"`
	DotfilesCloned        bool      `json:"dotfiles_cloned"`
	SymlinksCreated       bool      `json:"symlinks_created"`
	LastUpdated           time.Time `json:"last_updated"`
}

var (
	logFile    *os.File
	logger     *log.Logger
	stateFile  = ".setup-state.json"
	setupState SetupState
)

func main() {
	// Initialize logging
	if err := initLogging(); err != nil {
		fmt.Printf("Failed to initialize logging: %v\n", err)
		os.Exit(1)
	}
	defer logFile.Close()

	logger.Println("Starting dotfiles installation...")
	fmt.Println("=== Dotfiles Installation Tool ===")
	fmt.Println()

	// Load previous state if exists
	loadState()

	// Get user configuration
	config, err := getConfiguration()
	if err != nil {
		logger.Printf("Failed to get configuration: %v\n", err)
		fmt.Printf("Error: %v\n", err)
		os.Exit(1)
	}

	// Run installation steps
	if err := runInstallation(config); err != nil {
		logger.Printf("Installation failed: %v\n", err)
		fmt.Printf("\nInstallation failed: %v\n", err)
		fmt.Println("Check the log file for details: dotfiles-install.log")
		os.Exit(1)
	}

	logger.Println("Installation completed successfully!")
	fmt.Println("\n=== Installation completed successfully! ===")
	fmt.Println("Please restart your shell or run: source ~/.zshrc")
}

// initLogging sets up the log file
func initLogging() error {
	var err error
	logFile, err = os.OpenFile("dotfiles-install.log", os.O_CREATE|os.O_WRONLY|os.O_APPEND, 0644)
	if err != nil {
		return err
	}
	
	// Log only to file to avoid duplicate output
	logger = log.New(logFile, "[INSTALLER] ", log.LstdFlags)
	return nil
}

// loadState loads the previous installation state
func loadState() {
	data, err := os.ReadFile(stateFile)
	if err != nil {
		// No previous state, start fresh
		setupState = SetupState{}
		return
	}

	if err := json.Unmarshal(data, &setupState); err != nil {
		logger.Printf("Warning: Could not parse state file: %v\n", err)
		setupState = SetupState{}
	} else {
		logger.Printf("Loaded previous state from %s\n", setupState.LastUpdated.Format(time.RFC3339))
	}
}

// saveState saves the current installation state
func saveState() error {
	setupState.LastUpdated = time.Now()
	data, err := json.MarshalIndent(setupState, "", "  ")
	if err != nil {
		return err
	}
	return os.WriteFile(stateFile, data, 0644)
}

// getConfiguration prompts user for configuration options
func getConfiguration() (*Config, error) {
	currentUser, err := user.Current()
	if err != nil {
		return nil, fmt.Errorf("failed to get current user: %w", err)
	}

	config := &Config{
		HomeDir: currentUser.HomeDir,
	}

	reader := bufio.NewReader(os.Stdin)

	// Ask for dotfiles repository URL
	fmt.Print("Enter your dotfiles repository URL (or press Enter for default): ")
	repo, err := reader.ReadString('\n')
	if err != nil {
		return nil, fmt.Errorf("failed to read repository URL: %w", err)
	}
	repo = strings.TrimSpace(repo)
	if repo == "" {
		// Use a sensible default or the user's own repository
		config.DotfilesRepo = "https://github.com/Lance-N3rdlov3/dot-master.git"
	} else {
		config.DotfilesRepo = repo
	}

	// Ask about Zsh installation
	fmt.Print("Install Zsh if not present? (Y/n): ")
	response, err := reader.ReadString('\n')
	if err != nil {
		return nil, fmt.Errorf("failed to read Zsh installation preference: %w", err)
	}
	response = strings.TrimSpace(strings.ToLower(response))
	config.InstallZsh = response == "" || response == "y" || response == "yes"

	// Ask about Oh My Zsh installation
	fmt.Print("Install Oh My Zsh? (Y/n): ")
	response, err = reader.ReadString('\n')
	if err != nil {
		return nil, fmt.Errorf("failed to read Oh My Zsh installation preference: %w", err)
	}
	response = strings.TrimSpace(strings.ToLower(response))
	config.InstallOhMyZsh = response == "" || response == "y" || response == "yes"

	fmt.Println("\nConfiguration:")
	fmt.Printf("  Dotfiles Repo: %s\n", config.DotfilesRepo)
	fmt.Printf("  Install Zsh: %v\n", config.InstallZsh)
	fmt.Printf("  Install Oh My Zsh: %v\n", config.InstallOhMyZsh)
	fmt.Println()

	return config, nil
}

// runInstallation executes the installation steps
func runInstallation(config *Config) error {
	steps := []struct {
		name     string
		skip     bool
		skipMsg  string
		function func(*Config) error
	}{
		{"Installing dependencies", setupState.DependenciesInstalled, "Dependencies already installed", installDependencies},
		{"Installing Zsh", setupState.ZshInstalled || !config.InstallZsh, "Zsh installation skipped", installZsh},
		{"Installing Oh My Zsh", setupState.OhMyZshInstalled || !config.InstallOhMyZsh, "Oh My Zsh installation skipped", installOhMyZsh},
		{"Cloning dotfiles repository", setupState.DotfilesCloned, "Dotfiles already cloned", func(c *Config) error { return cloneDotfiles(c) }},
		{"Creating symlinks", setupState.SymlinksCreated, "Symlinks already created", func(c *Config) error { return createSymlinks(c) }},
	}

	for i, step := range steps {
		if step.skip {
			logger.Printf("[%d/%d] %s - SKIPPED: %s\n", i+1, len(steps), step.name, step.skipMsg)
			fmt.Printf("[%d/%d] %s - SKIPPED\n", i+1, len(steps), step.name)
			continue
		}

		logger.Printf("[%d/%d] %s...\n", i+1, len(steps), step.name)
		fmt.Printf("[%d/%d] %s...\n", i+1, len(steps), step.name)

		if err := step.function(config); err != nil {
			return fmt.Errorf("%s failed: %w", step.name, err)
		}

		// Save state after each successful step
		if err := saveState(); err != nil {
			logger.Printf("Warning: Failed to save state: %v\n", err)
		}
	}

	return nil
}

// installDependencies installs required system packages
func installDependencies(config *Config) error {
	packages := []string{"curl", "git"}

	// Detect package manager
	if commandExists("apt-get") {
		// Debian/Ubuntu
		if err := runCommand("sudo", "apt-get", "update"); err != nil {
			return fmt.Errorf("failed to update package list: %w", err)
		}
		installCmd := append([]string{"apt-get", "install", "-y"}, packages...)
		if err := runCommand("sudo", installCmd...); err != nil {
			return fmt.Errorf("failed to install dependencies: %w", err)
		}
	} else if commandExists("yum") {
		// RHEL/CentOS
		installCmd := append([]string{"yum", "install", "-y"}, packages...)
		if err := runCommand("sudo", installCmd...); err != nil {
			return fmt.Errorf("failed to install dependencies: %w", err)
		}
	} else if commandExists("dnf") {
		// Fedora
		installCmd := append([]string{"dnf", "install", "-y"}, packages...)
		if err := runCommand("sudo", installCmd...); err != nil {
			return fmt.Errorf("failed to install dependencies: %w", err)
		}
	} else if commandExists("pacman") {
		// Arch Linux
		installCmd := append([]string{"pacman", "-S", "--noconfirm"}, packages...)
		if err := runCommand("sudo", installCmd...); err != nil {
			return fmt.Errorf("failed to install dependencies: %w", err)
		}
	} else if commandExists("brew") {
		// macOS
		installCmd := append([]string{"install"}, packages...)
		if err := runCommand("brew", installCmd...); err != nil {
			return fmt.Errorf("failed to install dependencies: %w", err)
		}
	} else {
		logger.Println("Warning: Could not detect package manager. Assuming dependencies are installed.")
		setupState.DependenciesInstalled = true
		return nil
	}

	setupState.DependenciesInstalled = true
	logger.Println("Dependencies installed successfully")
	return nil
}

// installZsh installs Zsh shell
func installZsh(config *Config) error {
	if commandExists("zsh") {
		logger.Println("Zsh is already installed")
		setupState.ZshInstalled = true
		return nil
	}

	logger.Println("Installing Zsh...")

	if commandExists("apt-get") {
		if err := runCommand("sudo", "apt-get", "update"); err != nil {
			return fmt.Errorf("failed to update package list: %w", err)
		}
		if err := runCommand("sudo", "apt-get", "install", "-y", "zsh"); err != nil {
			return fmt.Errorf("failed to install Zsh: %w", err)
		}
	} else if commandExists("yum") {
		if err := runCommand("sudo", "yum", "install", "-y", "zsh"); err != nil {
			return fmt.Errorf("failed to install Zsh: %w", err)
		}
	} else if commandExists("dnf") {
		if err := runCommand("sudo", "dnf", "install", "-y", "zsh"); err != nil {
			return fmt.Errorf("failed to install Zsh: %w", err)
		}
	} else if commandExists("pacman") {
		if err := runCommand("sudo", "pacman", "-S", "--noconfirm", "zsh"); err != nil {
			return fmt.Errorf("failed to install Zsh: %w", err)
		}
	} else if commandExists("brew") {
		if err := runCommand("brew", "install", "zsh"); err != nil {
			return fmt.Errorf("failed to install Zsh: %w", err)
		}
	} else {
		return fmt.Errorf("could not detect package manager to install Zsh")
	}

	setupState.ZshInstalled = true
	logger.Println("Zsh installed successfully")
	return nil
}

// installOhMyZsh installs Oh My Zsh and plugins
func installOhMyZsh(config *Config) error {
	ohMyZshDir := filepath.Join(config.HomeDir, ".oh-my-zsh")

	if _, err := os.Stat(ohMyZshDir); err == nil {
		logger.Println("Oh My Zsh is already installed")
		setupState.OhMyZshInstalled = true
		return nil
	}

	logger.Println("Installing Oh My Zsh...")

	// Download and run Oh My Zsh installer with pinned version for security
	// Using a specific commit hash instead of master branch
	installScript := `sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/c0b0cf2e66217f6e85e45726e97941287c568126/tools/install.sh)" "" --unattended`
	cmd := exec.Command("sh", "-c", installScript)
	cmd.Env = os.Environ()
	cmd.Stdout = logFile
	cmd.Stderr = logFile

	if err := cmd.Run(); err != nil {
		return fmt.Errorf("failed to install Oh My Zsh: %w", err)
	}

	// Install popular plugins
	if err := installOhMyZshPlugins(config); err != nil {
		logger.Printf("Warning: Failed to install some plugins: %v\n", err)
	}

	setupState.OhMyZshInstalled = true
	logger.Println("Oh My Zsh installed successfully")
	return nil
}

// installOhMyZshPlugins installs popular Oh My Zsh plugins
func installOhMyZshPlugins(config *Config) error {
	customPluginsDir := filepath.Join(config.HomeDir, ".oh-my-zsh", "custom", "plugins")

	plugins := map[string]string{
		"zsh-autosuggestions":      "https://github.com/zsh-users/zsh-autosuggestions.git",
		"zsh-syntax-highlighting": "https://github.com/zsh-users/zsh-syntax-highlighting.git",
	}

	for name, repo := range plugins {
		pluginDir := filepath.Join(customPluginsDir, name)
		if _, err := os.Stat(pluginDir); err == nil {
			logger.Printf("Plugin %s already installed\n", name)
			continue
		}

		logger.Printf("Installing plugin: %s\n", name)
		if err := runCommand("git", "clone", repo, pluginDir); err != nil {
			logger.Printf("Warning: Failed to install plugin %s: %v\n", name, err)
		}
	}

	return nil
}

// cloneDotfiles clones the dotfiles repository
func cloneDotfiles(config *Config) error {
	dotfilesDir := filepath.Join(config.HomeDir, ".dotfiles")

	if _, err := os.Stat(dotfilesDir); err == nil {
		logger.Println("Dotfiles directory already exists")
		setupState.DotfilesCloned = true
		return nil
	}

	logger.Printf("Cloning dotfiles from %s...\n", config.DotfilesRepo)

	if err := runCommand("git", "clone", config.DotfilesRepo, dotfilesDir); err != nil {
		return fmt.Errorf("failed to clone dotfiles: %w", err)
	}

	setupState.DotfilesCloned = true
	logger.Println("Dotfiles cloned successfully")
	return nil
}

// createSymlinks creates symlinks for dotfiles with backup
func createSymlinks(config *Config) error {
	dotfilesDir := filepath.Join(config.HomeDir, ".dotfiles")

	// Check if dotfiles directory exists
	if _, err := os.Stat(dotfilesDir); os.IsNotExist(err) {
		return fmt.Errorf("dotfiles directory does not exist: %s", dotfilesDir)
	}

	logger.Println("Creating symlinks for dotfiles...")

	// Common dotfiles to symlink
	dotfiles := []string{
		".zshrc",
		".bashrc",
		".vimrc",
		".gitconfig",
		".tmux.conf",
	}

	backupDir := filepath.Join(config.HomeDir, ".dotfiles-backup")
	if err := os.MkdirAll(backupDir, 0755); err != nil {
		return fmt.Errorf("failed to create backup directory: %w", err)
	}

	for _, dotfile := range dotfiles {
		sourcePath := filepath.Join(dotfilesDir, dotfile)
		targetPath := filepath.Join(config.HomeDir, dotfile)

		// Check if source file exists
		if _, err := os.Stat(sourcePath); os.IsNotExist(err) {
			logger.Printf("Skipping %s (not found in dotfiles)\n", dotfile)
			continue
		}

		// Backup existing file
		if _, err := os.Lstat(targetPath); err == nil {
			backupPath := filepath.Join(backupDir, dotfile+"."+time.Now().Format("20060102-150405"))
			logger.Printf("Backing up existing %s to %s\n", dotfile, backupPath)

			// If it's a symlink, remove it; otherwise, move it
			if fileInfo, err := os.Lstat(targetPath); err == nil && fileInfo.Mode()&os.ModeSymlink != 0 {
				if err := os.Remove(targetPath); err != nil {
					logger.Printf("Warning: Failed to remove existing symlink %s: %v\n", targetPath, err)
				}
			} else {
				if err := os.Rename(targetPath, backupPath); err != nil {
					logger.Printf("Warning: Failed to backup %s: %v\n", dotfile, err)
				}
			}
		}

		// Create symlink
		logger.Printf("Creating symlink: %s -> %s\n", targetPath, sourcePath)
		if err := os.Symlink(sourcePath, targetPath); err != nil {
			logger.Printf("Warning: Failed to create symlink for %s: %v\n", dotfile, err)
			continue
		}
	}

	// Also symlink .config directories if they exist
	configDir := filepath.Join(dotfilesDir, ".config")
	if _, err := os.Stat(configDir); err == nil {
		if err := symlinkConfigDirectory(configDir, config.HomeDir, backupDir); err != nil {
			logger.Printf("Warning: Failed to symlink .config directory: %v\n", err)
		}
	}

	setupState.SymlinksCreated = true
	logger.Println("Symlinks created successfully")
	return nil
}

// symlinkConfigDirectory symlinks configuration directories
func symlinkConfigDirectory(sourceConfigDir, homeDir, backupDir string) error {
	targetConfigDir := filepath.Join(homeDir, ".config")

	// Ensure target .config directory exists
	if err := os.MkdirAll(targetConfigDir, 0755); err != nil {
		return fmt.Errorf("failed to create .config directory: %w", err)
	}

	// Walk through source .config directory
	entries, err := os.ReadDir(sourceConfigDir)
	if err != nil {
		return fmt.Errorf("failed to read .config directory: %w", err)
	}

	for _, entry := range entries {
		sourcePath := filepath.Join(sourceConfigDir, entry.Name())
		targetPath := filepath.Join(targetConfigDir, entry.Name())

		// Backup existing file/directory
		if _, err := os.Lstat(targetPath); err == nil {
			backupPath := filepath.Join(backupDir, ".config-"+entry.Name()+"-"+time.Now().Format("20060102-150405"))
			logger.Printf("Backing up existing .config/%s to %s\n", entry.Name(), backupPath)

			if fileInfo, err := os.Lstat(targetPath); err == nil && fileInfo.Mode()&os.ModeSymlink != 0 {
				if err := os.Remove(targetPath); err != nil {
					logger.Printf("Warning: Failed to remove existing symlink %s: %v\n", targetPath, err)
				}
			} else {
				if err := os.Rename(targetPath, backupPath); err != nil {
					logger.Printf("Warning: Failed to backup .config/%s: %v\n", entry.Name(), err)
				}
			}
		}

		// Create symlink
		logger.Printf("Creating symlink: %s -> %s\n", targetPath, sourcePath)
		if err := os.Symlink(sourcePath, targetPath); err != nil {
			logger.Printf("Warning: Failed to create symlink for .config/%s: %v\n", entry.Name(), err)
		}
	}

	return nil
}

// commandExists checks if a command is available in PATH
func commandExists(cmd string) bool {
	_, err := exec.LookPath(cmd)
	return err == nil
}

// runCommand executes a command and logs output
func runCommand(name string, args ...string) error {
	cmd := exec.Command(name, args...)
	cmd.Stdout = logFile
	cmd.Stderr = logFile

	logger.Printf("Running command: %s %v\n", name, args)

	if err := cmd.Run(); err != nil {
		return fmt.Errorf("command failed: %s %v: %w", name, args, err)
	}

	return nil
}
