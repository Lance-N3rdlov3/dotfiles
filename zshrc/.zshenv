#
# ~/.zshenv
# Environment variables for all shells (login, interactive, and scripts)
#

# OS Detection
if [[ "$OSTYPE" == "darwin"* ]]; then
    export IS_MACOS=1
    export IS_LINUX=0
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
    export IS_LINUX=1
    export IS_MACOS=0
    # Check if running HyDE (HyprDE)
    if [[ -n "$HYPRLAND_INSTANCE_SIGNATURE" ]] || command -v hyprctl &>/dev/null; then
        export IS_HYDE=1
    else
        export IS_HYDE=0
    fi
else
    export IS_MACOS=0
    export IS_LINUX=0
    export IS_HYDE=0
fi

# PATH configuration
# Add ~/.local/bin if it exists
if [[ -d "$HOME/.local/bin" ]]; then
    export PATH="$HOME/.local/bin:$PATH"
fi

# Add additional paths
export PATH="$HOME/bin:$HOME/.var:$HOME/.bin:$HOME/go/bin:$HOME/.pkgx/bin:$PATH"

# macOS specific paths
if [[ $IS_MACOS -eq 1 ]]; then
    # Homebrew paths
    if [[ -d "/opt/homebrew/bin" ]]; then
        export PATH="/opt/homebrew/bin:$PATH"
    fi
    if [[ -d "/usr/local/bin" ]]; then
        export PATH="/usr/local/bin:$PATH"
    fi
fi

# Linux specific paths
if [[ $IS_LINUX -eq 1 ]]; then
    export PATH="/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:$PATH"
fi

# Application-specific environment variables
export OLLAMA_API_BASE=http://127.0.0.1:11434

# Mcfly configuration (history search)
export MCFLY_FUZZY=true
export MCFLY_RESULTS=20
export MCFLY_INTERFACE_VIEW=BOTTOM
export MCFLY_RESULTS_SORT=LAST_RUN
