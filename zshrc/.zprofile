#
# ~/.zprofile
# Sourced for login shells
#

# Source .zshenv if it hasn't been sourced yet
if [[ -f "$HOME/.zshenv" ]]; then
    source "$HOME/.zshenv"
fi

# Login shell specific settings can be added here
# For example: starting graphical session, tmux, etc.
