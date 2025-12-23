# Installation Flow Diagram

This document illustrates the step-by-step flow of the dotfiles installer.

## High-Level Flow

```
┌─────────────────────────────────────────────────────────┐
│                  Start Installation                      │
└───────────────────────┬─────────────────────────────────┘
                        │
                        ▼
┌─────────────────────────────────────────────────────────┐
│            Initialize Logging System                     │
│      (Create dotfiles-install.log)                      │
└───────────────────────┬─────────────────────────────────┘
                        │
                        ▼
┌─────────────────────────────────────────────────────────┐
│         Load Previous State (if exists)                  │
│      (Read .setup-state.json)                           │
└───────────────────────┬─────────────────────────────────┘
                        │
                        ▼
┌─────────────────────────────────────────────────────────┐
│         Interactive Configuration                        │
│  ┌─────────────────────────────────────────────┐       │
│  │ • Dotfiles repository URL                    │       │
│  │ • Install Zsh? (Y/n)                         │       │
│  │ • Install Oh My Zsh? (Y/n)                   │       │
│  └─────────────────────────────────────────────┘       │
└───────────────────────┬─────────────────────────────────┘
                        │
                        ▼
┌─────────────────────────────────────────────────────────┐
│              Installation Pipeline                       │
│  ┌──────────────────────────────────────────────┐      │
│  │  Step 1: Install Dependencies                 │      │
│  │  ├─ Detect package manager                    │      │
│  │  ├─ Update package lists                      │      │
│  │  └─ Install curl, git                         │      │
│  └──────────────────────────────────────────────┘      │
│               │                                          │
│               ▼                                          │
│  ┌──────────────────────────────────────────────┐      │
│  │  Step 2: Install Zsh (if requested)           │      │
│  │  ├─ Check if already installed                │      │
│  │  ├─ Detect package manager                    │      │
│  │  └─ Install zsh package                       │      │
│  └──────────────────────────────────────────────┘      │
│               │                                          │
│               ▼                                          │
│  ┌──────────────────────────────────────────────┐      │
│  │  Step 3: Install Oh My Zsh (if requested)     │      │
│  │  ├─ Check if already installed                │      │
│  │  ├─ Download & run install script             │      │
│  │  └─ Install plugins:                          │      │
│  │     • zsh-autosuggestions                     │      │
│  │     • zsh-syntax-highlighting                 │      │
│  └──────────────────────────────────────────────┘      │
│               │                                          │
│               ▼                                          │
│  ┌──────────────────────────────────────────────┐      │
│  │  Step 4: Clone Dotfiles Repository            │      │
│  │  ├─ Clone to ~/.dotfiles/                     │      │
│  │  └─ Use configured repo URL                   │      │
│  └──────────────────────────────────────────────┘      │
│               │                                          │
│               ▼                                          │
│  ┌──────────────────────────────────────────────┐      │
│  │  Step 5: Create Symlinks                      │      │
│  │  ├─ Create backup directory                   │      │
│  │  ├─ For each dotfile:                         │      │
│  │  │  ├─ Backup existing file (timestamped)     │      │
│  │  │  └─ Create symlink                         │      │
│  │  ├─ Symlink root files (.zshrc, etc.)         │      │
│  │  └─ Symlink .config directories               │      │
│  └──────────────────────────────────────────────┘      │
│               │                                          │
│               ▼                                          │
│       ┌───────────────────┐                             │
│       │ Save State After  │                             │
│       │   Each Step       │                             │
│       └───────────────────┘                             │
└───────────────────────┬─────────────────────────────────┘
                        │
                        ▼
┌─────────────────────────────────────────────────────────┐
│              Installation Complete!                      │
│   • All files logged to dotfiles-install.log           │
│   • State saved to .setup-state.json                    │
│   • Backups in ~/.dotfiles-backup/                      │
└─────────────────────────────────────────────────────────┘
```

## State Management

Each step checks if it has been completed before:

```
┌──────────────────┐     ┌─────────────────┐
│  Read State      │────▶│  Step Already   │────▶ Skip
│  (.setup-state)  │     │  Complete?      │
└──────────────────┘     └────────┬────────┘
                                  │ No
                                  ▼
                         ┌─────────────────┐
                         │  Execute Step   │
                         └────────┬────────┘
                                  │
                                  ▼
                         ┌─────────────────┐
                         │  Save State     │
                         └─────────────────┘
```

## Error Handling

```
┌──────────────────┐
│  Execute Step    │
└────────┬─────────┘
         │
         ▼
    ┌────────┐
    │Success?│
    └───┬─┬──┘
        │ │
     Yes│ │No
        │ │
        │ └─────────────────┐
        │                   ▼
        │          ┌──────────────────┐
        │          │  Log Error       │
        │          │  Preserve State  │
        │          │  Show Message    │
        │          └────────┬─────────┘
        │                   │
        │                   ▼
        │          ┌──────────────────┐
        │          │  Exit with Error │
        │          └──────────────────┘
        │
        ▼
┌──────────────────┐
│  Continue to     │
│  Next Step       │
└──────────────────┘
```

## File Backup Process

```
┌─────────────────────┐
│  Check if file      │
│  exists at target   │
└──────────┬──────────┘
           │
           ▼
      ┌────────┐
      │Exists? │
      └───┬─┬──┘
          │ │
       Yes│ │No
          │ │
          │ └────────────────────┐
          │                      │
          ▼                      │
┌─────────────────────┐         │
│  Is it a symlink?   │         │
└──────────┬──────────┘         │
           │                     │
           ▼                     │
      ┌────────┐                │
      │Yes? No?│                │
      └───┬─┬──┘                │
          │ │                   │
      Yes │ │ No                │
          │ │                   │
          │ └──────┐            │
          │        │            │
          ▼        ▼            │
┌─────────────┐ ┌──────────┐  │
│Remove link  │ │Move to   │  │
│             │ │backup dir│  │
└──────┬──────┘ └────┬─────┘  │
       │             │         │
       └──────┬──────┘         │
              │                │
              └────────┬───────┘
                       │
                       ▼
              ┌─────────────────┐
              │ Create symlink  │
              │ to dotfile      │
              └─────────────────┘
```

## Configuration Prompts

```
User starts installer
        │
        ▼
┌──────────────────────────────────────────┐
│  Prompt: Enter dotfiles repository URL   │
│  Default: Lance-N3rdlov3/dot-master.git  │
└──────────────────┬───────────────────────┘
                   │
                   ▼
┌──────────────────────────────────────────┐
│  Prompt: Install Zsh if not present?     │
│  Default: Y                              │
└──────────────────┬───────────────────────┘
                   │
                   ▼
┌──────────────────────────────────────────┐
│  Prompt: Install Oh My Zsh?              │
│  Default: Y                              │
└──────────────────┬───────────────────────┘
                   │
                   ▼
┌──────────────────────────────────────────┐
│  Display configuration summary           │
│  Begin installation                      │
└──────────────────────────────────────────┘
```

## Package Manager Detection

```
┌──────────────────┐
│  Need to install │
│  package         │
└────────┬─────────┘
         │
         ▼
    ┌────────────────────────────────────┐
    │  Check for package managers:       │
    │  ┌──────────────────────────────┐  │
    │  │ apt-get → Debian/Ubuntu      │  │
    │  │ yum     → RHEL/CentOS        │  │
    │  │ dnf     → Fedora             │  │
    │  │ pacman  → Arch Linux         │  │
    │  │ brew    → macOS              │  │
    │  └──────────────────────────────┘  │
    └────────┬───────────────────────────┘
             │
             ▼
    ┌────────────────┐
    │  Use detected  │
    │  package mgr   │
    └────────┬───────┘
             │
             ▼
    ┌────────────────┐
    │  Install pkg   │
    └────────────────┘
```

## Resumable Installation

If the installation is interrupted at any point:

```
┌─────────────────────────────────────┐
│  Previous run interrupted at Step 3  │
└──────────────────┬──────────────────┘
                   │
                   ▼
┌─────────────────────────────────────┐
│  Load .setup-state.json              │
│  ┌───────────────────────────────┐  │
│  │ dependencies_installed: true   │  │
│  │ zsh_installed: true            │  │
│  │ oh_my_zsh_installed: false     │  │
│  │ dotfiles_cloned: false         │  │
│  │ symlinks_created: false        │  │
│  └───────────────────────────────┘  │
└──────────────────┬──────────────────┘
                   │
                   ▼
┌─────────────────────────────────────┐
│  Resume from Step 3:                 │
│  Install Oh My Zsh                   │
└──────────────────┬──────────────────┘
                   │
                   ▼
         Continue normally...
```

## Directory Structure After Installation

```
$HOME/
├── .dotfiles/                    # Cloned dotfiles repo
│   ├── .zshrc
│   ├── .bashrc
│   ├── .vimrc
│   ├── .gitconfig
│   └── .config/
│       ├── nvim/
│       └── alacritty/
├── .dotfiles-backup/             # Backups
│   ├── .zshrc.20251223-120000
│   └── .vimrc.20251223-120001
├── .oh-my-zsh/                   # Oh My Zsh
│   └── custom/
│       └── plugins/
│           ├── zsh-autosuggestions/
│           └── zsh-syntax-highlighting/
├── .zshrc → .dotfiles/.zshrc     # Symlinks
├── .bashrc → .dotfiles/.bashrc
├── .vimrc → .dotfiles/.vimrc
├── .gitconfig → .dotfiles/.gitconfig
└── .config/
    ├── nvim → .dotfiles/.config/nvim
    └── alacritty → .dotfiles/.config/alacritty
```

## Logging

All operations are logged to `dotfiles-install.log`:

```
[INSTALLER] 2025/12/23 12:00:00 Starting dotfiles installation...
[INSTALLER] 2025/12/23 12:00:01 [1/5] Installing dependencies...
[INSTALLER] 2025/12/23 12:00:01 Running command: sudo [apt-get update]
[INSTALLER] 2025/12/23 12:00:15 Running command: sudo [apt-get install -y curl git]
[INSTALLER] 2025/12/23 12:00:30 Dependencies installed successfully
[INSTALLER] 2025/12/23 12:00:30 [2/5] Installing Zsh...
...
```

This comprehensive flow ensures a safe, resumable, and user-friendly installation experience.
