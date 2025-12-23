# Zsh Configuration

This directory contains a well-organized Zsh configuration that follows best practices and supports multiple operating systems (Linux/HyDE and macOS).

## File Structure

### `.zshenv`
**Purpose**: Environment variables for ALL shells (login, interactive, and scripts)

**Contains**:
- OS detection (sets `IS_LINUX`, `IS_MACOS`, `IS_HYDE` variables)
- PATH configuration (with OS-specific paths)
- Application environment variables (OLLAMA_API_BASE, MCFLY_* settings)

**When loaded**: Always, for all shell types

### `.zprofile`
**Purpose**: Configuration for login shells

**Contains**:
- Sources `.zshenv` if not already loaded
- Placeholder for login-specific settings (e.g., starting graphical sessions, tmux)

**When loaded**: Only for login shells

### `.zshrc`
**Purpose**: Configuration for interactive shells

**Contains**:
- Shell options (completion, history, globbing, etc.)
- History configuration
- Completion system setup
- Key bindings (emacs-style with extensive terminal support)
- Prompt configuration (Starship)
- OS-specific plugin loading:
  - **Linux**: System-installed plugins from `/usr/share/zsh/plugins/`
  - **macOS**: Homebrew-installed plugins
- Comprehensive aliases with OS detection
- Command existence checks to prevent errors

**When loaded**: For interactive shells

### `.zshrc.bup`
The original backup file. Can be removed after testing the new configuration.

## Installation

1. **Backup your current configuration** (if you have one):
   ```bash
   mv ~/.zshenv ~/.zshenv.old
   mv ~/.zprofile ~/.zprofile.old
   mv ~/.zshrc ~/.zshrc.old
   ```

2. **Create symlinks** to use this configuration:
   ```bash
   ln -sf "$(pwd)/.zshenv" ~/.zshenv
   ln -sf "$(pwd)/.zprofile" ~/.zprofile
   ln -sf "$(pwd)/.zshrc" ~/.zshrc
   ```

3. **Restart your shell** or source the configuration:
   ```bash
   source ~/.zshrc
   ```

## OS-Specific Features

### Linux/HyDE
- Arch Linux package management aliases (pacman, paru/yay)
- Garuda Linux specific commands
- System plugin locations (`/usr/share/zsh/plugins/`)
- Command-not-found hooks for Arch Linux
- Reflector mirror management
- Systemd journal shortcuts

### macOS
- Homebrew plugin support (`/opt/homebrew` or `/usr/local`)
- macOS-specific utilities (Finder, DNS flushing)
- BSD-style command flags

### Cross-Platform
- Modern tool replacements (exa/eza, bat, ugrep)
- Mcfly history search
- FZF integration
- Starship prompt
- Standard Unix utilities with color support

## Key Features

### Smart Alias Loading
Aliases are only created if the required command exists, preventing errors on systems where certain tools aren't installed.

### Modern Tool Support
- **exa/eza**: Modern `ls` replacement (eza is preferred as exa's successor)
- **bat**: Better `cat` with syntax highlighting
- **ugrep**: Better `grep` with Unicode support
- **mcfly**: Intelligent history search
- **starship**: Fast, customizable prompt

### Extensive Key Bindings
- Emacs-style editing (can be changed to vi-style)
- Smart history search with arrow keys
- Word navigation with Ctrl/Alt + Arrow keys
- Full terminal compatibility with terminfo

### Completion System
- Case-insensitive completion
- Colored completion based on file types
- Cached completions for speed
- Automatic rehashing of new executables
- Bash completion compatibility

## Environment Variables

Set in `.zshenv` and available to all shells:

- `IS_LINUX`: 1 if running on Linux, 0 otherwise
- `IS_MACOS`: 1 if running on macOS, 0 otherwise
- `IS_HYDE`: 1 if running HyprDE/HyDE, 0 otherwise
- `OLLAMA_API_BASE`: Ollama API endpoint
- `MCFLY_*`: Mcfly configuration variables

## Customization

### Adding Your Own Settings

1. **Environment Variables**: Add to `.zshenv`
2. **Login Shell Settings**: Add to `.zprofile`
3. **Interactive Settings**: Add to `.zshrc`

### Creating Local Overrides

Create a `~/.zshrc.local` file for machine-specific settings and add this to the end of `.zshrc`:

```zsh
# Load local configuration if it exists
[[ -f ~/.zshrc.local ]] && source ~/.zshrc.local
```

## Testing

To test the configuration without affecting your current setup:

```bash
# Test in a new shell
zsh -c 'source /path/to/.zshenv; source /path/to/.zshrc; echo "Config loaded successfully"'
```

## Troubleshooting

### Plugins Not Loading
Check that the plugins are installed in the correct location for your OS:
- **Linux**: `/usr/share/zsh/plugins/`
- **macOS**: Homebrew directory (run `brew --prefix`)

### Starship Not Showing
Install Starship: https://starship.rs/

### Slow Startup
- Disable plugins you don't need by commenting them out in `.zshrc`
- Check completion cache (`~/.cache/zcache`)
- Use `zsh -xv` to see what's being loaded

## Migration from Old Configuration

The old `.zshrc.bup` file contained everything in a single file. The new structure separates concerns:

- **Environment variables** → `.zshenv`
- **Login settings** → `.zprofile`
- **Interactive settings** → `.zshrc`

All functionality from the original file is preserved with the following improvements:
- OS detection and conditional loading
- Better organization
- Command existence checks
- Support for both Linux and macOS
- Modern tool alternatives (eza as exa replacement)

## Additional Resources

- [Zsh Documentation](http://zsh.sourceforge.net/Doc/)
- [Zsh Startup Files](http://zsh.sourceforge.net/Intro/intro_3.html)
- [Starship Prompt](https://starship.rs/)
- [Arch Linux Zsh Wiki](https://wiki.archlinux.org/title/Zsh)
