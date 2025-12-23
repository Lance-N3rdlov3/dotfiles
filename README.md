# Dotfiles Installation Tool

A powerful, resumable Go-based installer for managing your dotfiles with ease. This tool automates the setup of your development environment, including shell configuration, version control, and dotfile management.

## Features

- 🚀 **One-command installation**: Compile and run to set up your entire environment
- 🔄 **Resumable**: Installation state is tracked; you can restart at any time
- 🛡️ **Safe backups**: Automatically backs up existing files before overwriting
- 🎯 **Interactive configuration**: Prompts for user preferences
- 📝 **Comprehensive logging**: All actions are logged for troubleshooting
- 🔧 **Cross-platform**: Supports multiple Linux distributions and macOS
- ⚙️ **Customizable**: Configure dotfiles repository and installation options

## What It Does

1. **Installs system dependencies**: curl, git, and other essential tools
2. **Installs Zsh**: Optionally installs and configures Zsh shell
3. **Sets up Oh My Zsh**: Installs Oh My Zsh with popular plugins:
   - zsh-autosuggestions
   - zsh-syntax-highlighting
4. **Clones your dotfiles**: Downloads your dotfiles from a Git repository
5. **Creates symlinks**: Links dotfiles to your home directory with automatic backup
6. **Preserves progress**: Saves state after each step for safe resumption

## Prerequisites

- Go 1.21 or later (for compilation)
- Internet connection (for downloading dependencies)
- Unix-like operating system (Linux, macOS, or WSL)
- Sudo privileges (for installing system packages)

## Quick Start

### 1. Clone this repository

```bash
git clone https://github.com/Lance-N3rdlov3/dotfiles.git
cd dotfiles
```

### 2. Compile the installer

```bash
go build -o dotfiles-installer main.go
```

Or use the shorter command:

```bash
go build
```

This will create an executable named `dotfiles` in the current directory.

### 3. Run the installer

```bash
./dotfiles-installer
```

Or if you used the shorter build command:

```bash
./dotfiles
```

### 4. Follow the prompts

The installer will ask you for:
- Your dotfiles repository URL (default: https://github.com/Lance-N3rdlov3/dot-master.git)
- Whether to install Zsh (if not already installed)
- Whether to install Oh My Zsh

### 5. Restart your shell

After installation completes:

```bash
# If you installed Zsh
exec zsh

# Or reload your configuration
source ~/.zshrc
```

## Configuration Options

During installation, you'll be prompted for the following options:

- **Dotfiles Repository URL**: The Git repository containing your dotfiles
  - Default: `https://github.com/Lance-N3rdlov3/dot-master.git`
  - Press Enter to use the default or provide your own URL

- **Install Zsh**: Whether to install Zsh if it's not already present
  - Default: Yes (Y)
  - Skipped if Zsh is already installed

- **Install Oh My Zsh**: Whether to install Oh My Zsh framework
  - Default: Yes (Y)
  - Skipped if Oh My Zsh is already installed

## Dotfiles Repository Structure

Your dotfiles repository should follow this structure:

```
your-dotfiles-repo/
├── .zshrc              # Zsh configuration
├── .bashrc             # Bash configuration
├── .vimrc              # Vim configuration
├── .gitconfig          # Git configuration
├── .tmux.conf          # Tmux configuration
└── .config/            # Application configs
    ├── nvim/
    ├── alacritty/
    └── ...
```

The installer will:
- Symlink files from the root of your dotfiles repo to your home directory
- Symlink directories from `.config/` to `~/.config/`
- Back up any existing files before creating symlinks

## Installation State

The installer creates a `.setup-state.json` file to track progress:

```json
{
  "dependencies_installed": true,
  "zsh_installed": true,
  "oh_my_zsh_installed": true,
  "dotfiles_cloned": true,
  "symlinks_created": true,
  "last_updated": "2025-12-23T12:34:56Z"
}
```

If installation is interrupted, you can simply run the installer again, and it will skip completed steps.

## Logging

All installation steps are logged to `dotfiles-install.log`. If something goes wrong, check this file for detailed error messages:

```bash
cat dotfiles-install.log
```

## Backup Files

Before overwriting any existing dotfiles, the installer creates backups in `~/.dotfiles-backup/` with timestamps:

```
~/.dotfiles-backup/
├── .zshrc.20251223-123456
├── .vimrc.20251223-123456
└── .config-nvim-20251223-123456
```

## Supported Package Managers

The installer automatically detects and uses the appropriate package manager:

- **Debian/Ubuntu**: apt-get
- **RHEL/CentOS**: yum
- **Fedora**: dnf
- **Arch Linux**: pacman
- **macOS**: brew

## Advanced Usage

### Compile for different architectures

For Linux:
```bash
GOOS=linux GOARCH=amd64 go build -o dotfiles-installer-linux main.go
```

For macOS:
```bash
GOOS=darwin GOARCH=amd64 go build -o dotfiles-installer-macos main.go
```

For ARM (e.g., Raspberry Pi):
```bash
GOOS=linux GOARCH=arm64 go build -o dotfiles-installer-arm main.go
```

### Reset installation state

To start fresh:

```bash
rm .setup-state.json
./dotfiles-installer
```

### Non-interactive mode

For non-interactive installations, you'll need to modify the code to accept command-line flags or environment variables. Future versions may support this feature.

## Security Considerations

This tool follows security best practices:

- **Package Manager Verification**: Uses official package managers (apt, yum, dnf, pacman, brew) to install dependencies
- **HTTPS Git Clones**: All Git operations use HTTPS URLs
- **Backup Before Overwrite**: Creates timestamped backups before replacing any files
- **State Persistence**: Installation state is saved locally in a JSON file
- **Oh My Zsh Installation**: Uses the official installation script from the Oh My Zsh repository

**Note**: The installer downloads and executes the Oh My Zsh installation script from GitHub. This is the [officially recommended method](https://ohmyz.sh/#install) by the Oh My Zsh team. If you prefer additional verification, you can:
1. Fork the Oh My Zsh repository and use your own URL
2. Review the installation script before running this tool
3. Manually install Oh My Zsh and skip that step when prompted

## Troubleshooting

### Permission denied errors

If you get permission errors:

```bash
chmod +x dotfiles-installer
./dotfiles-installer
```

### Sudo password prompts

The installer needs sudo access to install system packages. You'll be prompted for your password when needed.

### Repository not found

Ensure your dotfiles repository URL is correct and accessible:

```bash
git clone YOUR_DOTFILES_URL
```

### Oh My Zsh installation fails

Oh My Zsh requires curl. Ensure it's installed:

```bash
which curl
```

## Contributing

Contributions are welcome! Feel free to submit issues or pull requests.

## License

This project is open source and available under the MIT License.

## Acknowledgments

- [Oh My Zsh](https://ohmyz.sh/) - Framework for managing Zsh configuration
- [zsh-autosuggestions](https://github.com/zsh-users/zsh-autosuggestions) - Fish-like autosuggestions for Zsh
- [zsh-syntax-highlighting](https://github.com/zsh-users/zsh-syntax-highlighting) - Syntax highlighting for Zsh

## Contact

For questions or support, please open an issue on GitHub.

---

**Happy dotfile managing! 🎉**
