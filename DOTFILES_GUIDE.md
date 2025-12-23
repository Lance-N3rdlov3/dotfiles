# Example Dotfiles Repository Structure

This document shows an example structure for your dotfiles repository that works with this installer.

## Recommended Structure

```
your-dotfiles-repo/
├── .zshrc              # Zsh configuration
├── .bashrc             # Bash configuration  
├── .vimrc              # Vim configuration
├── .gitconfig          # Git configuration
├── .tmux.conf          # Tmux configuration
├── .config/            # Modern app configs
│   ├── nvim/          # Neovim config
│   │   └── init.vim
│   ├── alacritty/     # Alacritty terminal
│   │   └── alacritty.yml
│   ├── tmux/          # Tmux config
│   │   └── tmux.conf
│   └── zsh/           # Additional Zsh configs
│       └── aliases.zsh
└── README.md          # Documentation
```

## How It Works

The installer will:

1. Clone your repository to `~/.dotfiles/`
2. Create symlinks from files in the root of your repo to your home directory
3. Create symlinks from directories in `.config/` to `~/.config/`
4. Backup any existing files before creating symlinks

## Example Files

### .zshrc

```bash
# Path to oh-my-zsh installation
export ZSH="$HOME/.oh-my-zsh"

# Theme
ZSH_THEME="robbyrussell"

# Plugins
plugins=(
  git
  zsh-autosuggestions
  zsh-syntax-highlighting
  docker
  kubectl
)

source $ZSH/oh-my-zsh.sh

# User configuration
export PATH="$HOME/bin:/usr/local/bin:$PATH"

# Aliases
alias ll='ls -lah'
alias g='git'
alias d='docker'
alias k='kubectl'
```

### .gitconfig

```ini
[user]
    name = Your Name
    email = your.email@example.com

[core]
    editor = vim
    autocrlf = input

[alias]
    st = status
    co = checkout
    br = branch
    ci = commit
    unstage = reset HEAD --

[color]
    ui = auto
```

### .vimrc

```vim
" Basic settings
set number
set relativenumber
set expandtab
set tabstop=4
set shiftwidth=4
set autoindent
set smartindent

" Syntax highlighting
syntax on
filetype plugin indent on

" Search settings
set hlsearch
set incsearch
set ignorecase
set smartcase
```

## Creating Your Dotfiles Repository

1. **Initialize a new repository**:
   ```bash
   mkdir ~/my-dotfiles
   cd ~/my-dotfiles
   git init
   ```

2. **Copy your existing dotfiles**:
   ```bash
   cp ~/.zshrc .
   cp ~/.bashrc .
   cp ~/.vimrc .
   cp ~/.gitconfig .
   cp ~/.tmux.conf .
   ```

3. **Copy .config directories**:
   ```bash
   mkdir -p .config
   cp -r ~/.config/nvim .config/ 2>/dev/null || true
   cp -r ~/.config/alacritty .config/ 2>/dev/null || true
   ```

4. **Create a README**:
   ```bash
   echo "# My Dotfiles" > README.md
   echo "" >> README.md
   echo "Personal configuration files for my development environment." >> README.md
   ```

5. **Commit and push**:
   ```bash
   git add .
   git commit -m "Initial commit: Add dotfiles"
   git remote add origin https://github.com/yourusername/dotfiles.git
   git push -u origin main
   ```

6. **Use with this installer**:
   ```bash
   # Clone this installer
   git clone https://github.com/Lance-N3rdlov3/dotfiles.git
   cd dotfiles
   
   # Build and run
   go build -o installer main.go
   ./installer
   
   # When prompted, enter your dotfiles repository URL:
   # https://github.com/yourusername/dotfiles.git
   ```

## Tips

- **Keep sensitive data out**: Never commit files containing passwords, API keys, or other secrets
- **Use environment variables**: Reference environment variables in your configs for machine-specific values
- **Document your setup**: Include a README in your dotfiles repo explaining what's included
- **Version control**: Commit changes regularly as you update your configurations
- **Test in a VM**: Test your dotfiles on a fresh VM before using on your main system

## Advanced: Machine-Specific Configurations

You can handle machine-specific configs by:

1. **Using local includes** (.gitconfig example):
   ```ini
   [include]
       path = ~/.gitconfig.local
   ```

2. **Environment-based selection** (.zshrc example):
   ```bash
   if [[ "$HOSTNAME" == "work-laptop" ]]; then
       export WORK_MODE=true
       # Work-specific aliases and settings
   fi
   ```

3. **Separate branches**:
   - `main` branch: Common configs
   - `work` branch: Work machine configs
   - `personal` branch: Personal machine configs

## Resources

- [GitHub Dotfiles Guide](https://dotfiles.github.io/)
- [Awesome Dotfiles](https://github.com/webpro/awesome-dotfiles)
- [dotfiles.github.io](https://dotfiles.github.io/)
