#
# ~/.zshrc
# Configuration for interactive Zsh shells
#

# Source .zshenv to ensure environment variables are set
if [[ -f "$HOME/.zshenv" ]]; then
    source "$HOME/.zshenv"
fi

#
# Shell Options
#
setopt correct                      # Auto correct mistakes
setopt extendedglob                 # Extended globbing
setopt nocaseglob                   # Case insensitive globbing
setopt rcexpandparam                # Array expansion with parameters
setopt nocheckjobs                  # Don't warn about running processes when exiting
setopt numericglobsort              # Sort filenames numerically when it makes sense
setopt nobeep                       # No beep
setopt appendhistory                # Immediately append history instead of overwriting
setopt histignorealldups            # If a new command is a duplicate, remove the older one
setopt autocd                       # If only directory path is entered, cd there
setopt auto_pushd                   # Make cd push old directory onto directory stack
setopt pushd_ignore_dups            # Don't push duplicates onto the stack
setopt pushdminus                   # Swap meaning of cd +1 and cd -1

#
# History Configuration
#
HISTFILE=~/.zhistory
HISTSIZE=50000
SAVEHIST=10000

#
# Completion System
#
autoload -Uz compinit
compinit

zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'       # Case insensitive tab completion
zstyle ':completion:*' rehash true                              # Automatically find new executables in path
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"         # Colored completion
zstyle ':completion:*' completer _expand _complete _ignored _approximate
zstyle ':completion:*' menu select
zstyle ':completion:*' select-prompt '%SScrolling active: current selection at %p%s'
zstyle ':completion:*:descriptions' format '%U%F{cyan}%d%f%u'

# Speed up completions
zstyle ':completion:*' accept-exact '*(N)'
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path ~/.cache/zcache

# Load bash completion functions
autoload -U +X bashcompinit && bashcompinit

#
# Key Bindings
#
# Use emacs key bindings
bindkey -e

# [PageUp] - Up a line of history
if [[ -n "${terminfo[kpp]}" ]]; then
  bindkey -M emacs "${terminfo[kpp]}" up-line-or-history
  bindkey -M viins "${terminfo[kpp]}" up-line-or-history
  bindkey -M vicmd "${terminfo[kpp]}" up-line-or-history
fi

# [PageDown] - Down a line of history
if [[ -n "${terminfo[knp]}" ]]; then
  bindkey -M emacs "${terminfo[knp]}" down-line-or-history
  bindkey -M viins "${terminfo[knp]}" down-line-or-history
  bindkey -M vicmd "${terminfo[knp]}" down-line-or-history
fi

# Start typing + [Up-Arrow] - fuzzy find history forward
if [[ -n "${terminfo[kcuu1]}" ]]; then
  autoload -U up-line-or-beginning-search
  zle -N up-line-or-beginning-search
  bindkey -M emacs "${terminfo[kcuu1]}" up-line-or-beginning-search
  bindkey -M viins "${terminfo[kcuu1]}" up-line-or-beginning-search
  bindkey -M vicmd "${terminfo[kcuu1]}" up-line-or-beginning-search
fi

# Start typing + [Down-Arrow] - fuzzy find history backward
if [[ -n "${terminfo[kcud1]}" ]]; then
  autoload -U down-line-or-beginning-search
  zle -N down-line-or-beginning-search
  bindkey -M emacs "${terminfo[kcud1]}" down-line-or-beginning-search
  bindkey -M viins "${terminfo[kcud1]}" down-line-or-beginning-search
  bindkey -M vicmd "${terminfo[kcud1]}" down-line-or-beginning-search
fi

# [Home] - Go to beginning of line
if [[ -n "${terminfo[khome]}" ]]; then
  bindkey -M emacs "${terminfo[khome]}" beginning-of-line
  bindkey -M viins "${terminfo[khome]}" beginning-of-line
  bindkey -M vicmd "${terminfo[khome]}" beginning-of-line
fi

# [End] - Go to end of line
if [[ -n "${terminfo[kend]}" ]]; then
  bindkey -M emacs "${terminfo[kend]}"  end-of-line
  bindkey -M viins "${terminfo[kend]}"  end-of-line
  bindkey -M vicmd "${terminfo[kend]}"  end-of-line
fi

# [Shift-Tab] - move through the completion menu backwards
if [[ -n "${terminfo[kcbt]}" ]]; then
  bindkey -M emacs "${terminfo[kcbt]}" reverse-menu-complete
  bindkey -M viins "${terminfo[kcbt]}" reverse-menu-complete
  bindkey -M vicmd "${terminfo[kcbt]}" reverse-menu-complete
fi

# [Backspace] - delete backward
bindkey -M emacs '^?' backward-delete-char
bindkey -M viins '^?' backward-delete-char
bindkey -M vicmd '^?' backward-delete-char

# [Delete] - delete forward
if [[ -n "${terminfo[kdch1]}" ]]; then
  bindkey -M emacs "${terminfo[kdch1]}" delete-char
  bindkey -M viins "${terminfo[kdch1]}" delete-char
  bindkey -M vicmd "${terminfo[kdch1]}" delete-char
else
  bindkey -M emacs "^[[3~" delete-char
  bindkey -M viins "^[[3~" delete-char
  bindkey -M vicmd "^[[3~" delete-char
  bindkey -M emacs "^[3;5~" delete-char
  bindkey -M viins "^[3;5~" delete-char
  bindkey -M vicmd "^[3;5~" delete-char
fi

# Word navigation
typeset -g -A key
if (( ${+terminfo[smkx]} && ${+terminfo[rmkx]} )); then
    autoload -Uz add-zle-hook-widget
    function zle_application_mode_start { echoti smkx }
    function zle_application_mode_stop { echoti rmkx }
    add-zle-hook-widget -Uz zle-line-init zle_application_mode_start
    add-zle-hook-widget -Uz zle-line-finish zle_application_mode_stop
fi

# Control Left - go back a word
key[Control-Left]="${terminfo[kLFT5]}"
if [[ -n "${key[Control-Left]}" ]]; then
    bindkey -M emacs "${key[Control-Left]}"  backward-word
    bindkey -M viins "${key[Control-Left]}"  backward-word
    bindkey -M vicmd "${key[Control-Left]}"  backward-word
fi

# Control Right - go forward a word
key[Control-Right]="${terminfo[kRIT5]}"
if [[ -n "${key[Control-Right]}" ]]; then
    bindkey -M emacs "${key[Control-Right]}" forward-word
    bindkey -M viins "${key[Control-Right]}" forward-word
    bindkey -M vicmd "${key[Control-Right]}" forward-word
fi

# Alt Left - go back a word
key[Alt-Left]="${terminfo[kLFT3]}"
if [[ -n "${key[Alt-Left]}" ]]; then
    bindkey -M emacs "${key[Alt-Left]}"  backward-word
    bindkey -M viins "${key[Alt-Left]}"  backward-word
    bindkey -M vicmd "${key[Alt-Left]}"  backward-word
fi

# Alt Right - go forward a word
key[Alt-Right]="${terminfo[kRIT3]}"
if [[ -n "${key[Alt-Right]}" ]]; then
    bindkey -M emacs "${key[Alt-Right]}" forward-word
    bindkey -M viins "${key[Alt-Right]}" forward-word
    bindkey -M vicmd "${key[Alt-Right]}" forward-word
fi

#
# Prompt Configuration
#
# Initialize starship prompt
if command -v starship &>/dev/null; then
    eval "$(starship init zsh)"
fi

# Set window title
function set_win_title(){
    echo -ne "\033]0; $USER@$HOST:${PWD/$HOME/~} \007"
}
precmd_functions+=(set_win_title)

#
# Plugins
#

# Linux/HyDE specific plugins
if [[ $IS_LINUX -eq 1 ]]; then
    # Zsh syntax highlighting
    if [[ -f /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]]; then
        source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
    fi

    # Zsh autosuggestions
    if [[ -f /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh ]]; then
        source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
    fi

    # Zsh history substring search
    if [[ -f /usr/share/zsh/plugins/zsh-history-substring-search/zsh-history-substring-search.zsh ]]; then
        source /usr/share/zsh/plugins/zsh-history-substring-search/zsh-history-substring-search.zsh
    fi

    # FZF integration
    if [[ -f /usr/share/fzf/key-bindings.zsh ]]; then
        source /usr/share/fzf/key-bindings.zsh
    fi
    if [[ -f /usr/share/fzf/completion.zsh ]]; then
        source /usr/share/fzf/completion.zsh
    fi

    # Command-not-found hooks (Arch Linux)
    [[ -f /usr/share/doc/pkgfile/command-not-found.zsh ]] && source /usr/share/doc/pkgfile/command-not-found.zsh
    [[ -f /usr/share/doc/find-the-command/ftc.zsh ]] && source /usr/share/doc/find-the-command/ftc.zsh
fi

# macOS specific plugins
if [[ $IS_MACOS -eq 1 ]]; then
    # Homebrew path for plugins
    local HOMEBREW_PREFIX="/opt/homebrew"
    [[ ! -d "$HOMEBREW_PREFIX" ]] && HOMEBREW_PREFIX="/usr/local"

    # Zsh syntax highlighting
    if [[ -f "$HOMEBREW_PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ]]; then
        source "$HOMEBREW_PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
    fi

    # Zsh autosuggestions
    if [[ -f "$HOMEBREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh" ]]; then
        source "$HOMEBREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
    fi

    # FZF integration
    if [[ -f "$HOMEBREW_PREFIX/opt/fzf/shell/key-bindings.zsh" ]]; then
        source "$HOMEBREW_PREFIX/opt/fzf/shell/key-bindings.zsh"
    fi
    if [[ -f "$HOMEBREW_PREFIX/opt/fzf/shell/completion.zsh" ]]; then
        source "$HOMEBREW_PREFIX/opt/fzf/shell/completion.zsh"
    fi
fi

# Atuin history search (cross-platform)
# See: https://github.com/atuinsh/atuin
if command -v atuin &>/dev/null; then
    eval "$(atuin init zsh)"
fi

#
# Aliases
#

# Common aliases (cross-platform)
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias ......='cd ../../../../..'

# Modern replacements for common tools
if command -v exa &>/dev/null || command -v eza &>/dev/null; then
    # Use eza if available (exa successor), otherwise exa
    if command -v eza &>/dev/null; then
        local ls_cmd="eza"
    else
        local ls_cmd="exa"
    fi
    alias ls="$ls_cmd -aG --color=always --group-directories-first --icons --sort type"
    alias la="$ls_cmd -aG --color=always --group-directories-first --icons"
    alias ll="$ls_cmd -lG --color=always --group-directories-first --icons"
    alias lt="$ls_cmd -aT --color=always --group-directories-first --icons --sort name"
    alias l.="$ls_cmd -ald --color=always --group-directories-first --icons .*"
else
    # Fallback to standard ls with basic options
    if [[ $IS_MACOS -eq 1 ]]; then
        alias ls='ls -G'
        alias la='ls -A'
        alias ll='ls -lh'
    else
        alias ls='ls --color=auto'
        alias la='ls -A'
        alias ll='ls -lh'
    fi
fi

if command -v bat &>/dev/null; then
    alias cat='bat --style header --style snip --style changes --style header'
fi

# Use ripgrep if available, otherwise fall back to standard grep
if command -v rg &>/dev/null; then
    alias grep='rg --color=auto'
    # Note: ripgrep doesn't have fgrep/egrep equivalents, these stay as standard grep
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
else
    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# Archive utilities
alias tarnow='tar -acf'
alias untar='tar -zxvf'
alias wget='wget -c'

# Process management
alias psmem='ps auxf | sort -nr -k 4'
alias psmem10='ps auxf | sort -nr -k 4 | head -10'

# Network
alias ip='ip -color'

# Utility
alias tb='nc termbin.com 9999'
alias helpme='cht.sh --shell'

# Linux/Arch specific aliases
if [[ $IS_LINUX -eq 1 ]]; then
    # Arch/Garuda Linux specific
    if command -v pacman &>/dev/null; then
        alias fixpacman="sudo rm /var/lib/pacman/db.lck"
        alias rmpkg="sudo pacman -Rdd"
        alias cleanup='sudo pacman -Rns $(pacman -Qtdq)'
        alias gitpkg='pacman -Q | grep -i "\-git" | wc -l'
        alias big="expac -H M '%m\t%n' | sort -h | nl"
        alias rip="expac --timefmt='%Y-%m-%d %T' '%l\t%n %v' | sort | tail -200 | nl"
        
        # Help people new to Arch
        alias apt='man pacman'
        alias apt-get='man pacman'
        alias please='sudo'
    fi

    if command -v paru &>/dev/null && ! command -v yay &>/dev/null; then
        alias yay='paru'
    fi

    if command -v update-grub &>/dev/null; then
        alias grubup="sudo update-grub"
    fi

    if command -v garuda-update &>/dev/null; then
        alias upd='/usr/bin/garuda-update'
    fi

    if command -v reflector &>/dev/null; then
        alias mirror="sudo reflector -f 30 -l 30 --number 10 --verbose --save /etc/pacman.d/mirrorlist"
        alias mirrord="sudo reflector --latest 50 --number 20 --sort delay --save /etc/pacman.d/mirrorlist"
        alias mirrors="sudo reflector --latest 50 --number 20 --sort score --save /etc/pacman.d/mirrorlist"
        alias mirrora="sudo reflector --latest 50 --number 20 --sort age --save /etc/pacman.d/mirrorlist"
    fi

    if command -v journalctl &>/dev/null; then
        alias jctl="journalctl -p 3 -xb"
    fi

    if command -v pacdiff &>/dev/null; then
        alias pacdiff='sudo -H DIFFPROG=meld pacdiff'
    fi

    if command -v hwinfo &>/dev/null; then
        alias hw='hwinfo --short'
    fi

    alias dir='dir --color=auto'
    alias vdir='vdir --color=auto'
fi

# macOS specific aliases
if [[ $IS_MACOS -eq 1 ]]; then
    # macOS specific utilities
    alias showfiles='defaults write com.apple.finder AppleShowAllFiles YES; killall Finder'
    alias hidefiles='defaults write com.apple.finder AppleShowAllFiles NO; killall Finder'
    alias flushdns='sudo dscacheutil -flushcache; sudo killall -HUP mDNSResponder'
fi
