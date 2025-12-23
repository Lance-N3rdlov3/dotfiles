#  Startup 
# Commands to execute on startup (before the prompt is shown)
# Check if the interactive shell option is set
#if [[ $- == *i* ]]; then
#    # This is a good place to load graphic/ascii art, display system information, etc.
#    if command -v pokego >/dev/null; then
#        pokego --no-title -r 1,3,6
#    elif command -v pokemon-colorscripts >/dev/null; then
#        pokemon-colorscripts --no-title -r 1,3,6
#    elif command -v fastfetch >/dev/null; then
#        if do_render "image"; then
#            fastfetch --logo-type kitty
#        fi
#    fi
#fi

#   Overrides 
# HYDE_ZSH_NO_PLUGINS=1 # Set to 1 to disable loading of oh-my-zsh plugins, useful if you want to use your zsh plugins system 
# unset HYDE_ZSH_PROMPT # Uncomment to unset/disable loading of prompts from HyDE and let you load your own prompts
# HYDE_ZSH_COMPINIT_CHECK=1 # Set 24 (hours) per compinit security check // lessens startup time
# HYDE_ZSH_OMZ_DEFER=1 # Set to 1 to defer loading of oh-my-zsh plugins ONLY if prompt is already loaded

if [[ ${HYDE_ZSH_NO_PLUGINS} != "1" ]]; then
    #  OMZ Plugins 
    # manually add your oh-my-zsh plugins here
    plugins=(
        sudo
        git
        zsh-autosuggestions
        zsh-syntax-highlighting
        zsh-autosuggestions
        z
        dash
        zoxide
        command-not-found
        colored-man-pages
        colorize
        docker
        docker-compose
        fancy-ctrl-z
        flutter
        github
        golang
        kitty
        brew
        mise
        thefuck
        mosh
        ng
        node
        nodenv
        npm
        react-native
        ruby
        python
        tldr
        tmux
        themes
        thor
        toolbox
        virtualenv
        virtualenvwrapper
        zsh-navigation-tools
        zsh-interactive-cd
        aliases
        fzf-marks
        autojump
        vscode
        fzf
        eza
    )
fi

tm ()
{
    local man_page;
    man_page=$(man -k . | sort | fzf --prompt='Man Pages> ' --preview='echo {} | awk "{print \$1}" | xargs man' --preview-window=right:60%:wrap);
    man "$(echo "$man_page" | awk '{print $1}')"
}

function extract() {
  # Check if a file was provided
  if [ -z "$1" ]; then
    echo "Usage: extract <archive_file>"
    return 1
  fi

  # Check if the file exists
  if [ ! -f "$1" ]; then
    echo "Error: File '$1' not found."
    return 1
  fi

  case "$1" in
    # Tar archives
    *.tar.bz2|*.tbz|*.tbz2) tar xvjf "$1" ;;
    *.tar.gz|*.tgz) tar xvzf "$1" ;;
    *.tar.xz|*.txz) tar xvJf "$1" ;;
    *.tar.zst) tar --zstd -xvf "$1" ;;
    *.tar.lz4) tar --lz4 -xvf "$1" ;;
    *.tar) tar xvf "$1" ;;

    # Individual compressed files
    *.bz2) bunzip2 "$1" ;;
    *.gz) gunzip "$1" ;;
    *.xz) unxz "$1" ;;
    *.zst) zstd -d "$1" ;;
    *.lz4) lz4 -d "$1" ;;

    # Other archives
    *.zip) unzip "$1" ;;
    *.rar) unrar x "$1" ;;
    *.7z) 7z x "$1" ;;
    *.Z) uncompress "$1" ;;
    *.deb) ar x "$1" ;;
    *.rpm) rpm2cpio "$1" | cpio -idmv ;;

    # Fallback for unrecognized files
    *)
      echo "'$1' cannot be extracted with extract()"
      return 1
      ;;
  esac
}

function help() {
  if command -v bat >/dev/null 2>&1; then
    "$@" --help | bat --style=auto --paging=never --color=always
  else
    "$@" --help | cat
  fi
}


function y() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
	yazi "$@" --cwd-file="$tmp"
	IFS= read -r -d '' cwd < "$tmp"
	[ -n "$cwd" ] && [ "$cwd" != "$PWD" ] && builtin cd -- "$cwd"
	rm -f -- "$tmp"
}
