# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
#if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
#  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
#fi

# If you come from bash you might have to change your $PATH.
export PATH=$HOME/bin:/usr/local/bin:/opt/homebrew/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
#ZSH_THEME="" # set by `omz`

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to automatically update without prompting.
# DISABLE_UPDATE_PROMPT="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="yyyy-mm-dd"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
git
zsh-autosuggestions
zsh-syntax-highlighting
zsh-autosuggestions
z
git-open
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
autojump


vscode
fzf
eza
)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
 if [[ -n $SSH_CONNECTION ]]; then
   export EDITOR='nvim'
 else
   export EDITOR='nvim'
 fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# zsh-completions
if type brew &>/dev/null;then
   FPTH=$(brew --prefix)/share/zsh-completions:$FPATH

   autoload -Uz compinit
   compinit
fi

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
 alias zconf="nvim ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"
source ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
#source ~/.bashrc

alias mysql=/usr/local/mysql/bin/mysql
alias ls='eza -a --grid --group-directories-first --sort name --icons=always --color=always'
alias vim='nvim'
alias vi='nvim'
alias ra='TERM=xterm-256color ranger'
alias raj='TERM=xterm-256color ranger --choosedir=$HOME/.rangerdir; LASTDIR=`cat $HOME/.rangerdir`; cd "$LASTDIR"'
alias lt="eza -aTd --icons=always --color=always --sort Name"
alias reload="source ~/.zshrc"
alias cl="clear"
alias c='clear'
alias kconf='nvim ~/.config/kitty/kitty.conf'
# ranger 配置
export RANGER_LOAD_DEFAULT_RC=FALSE
# 使用,补全历史记录
bindkey ',' autosuggest-accept


# vi-mode 使用nvim作为默认打开工具
EDITOR=nvim
export EDITOR

bindkey '^h'  backward-char         #control+h：向左移动一个单词
bindkey '^l'  forward-char          #control+l：向右移动一个单词
bindkey '^k'  up-line-or-history    #control+k：向上翻看历史记录
bindkey '^j'  down-line-or-history  #control+j：向下翻看历史记录


export FZF_DEFAULT_OPTS=" \
--color=bg+:#414559,bg:#303446,spinner:#F2D5CF,hl:#E78284 \
--color=fg:#C6D0F5,header:#E78284,info:#CA9EE6,pointer:#F2D5CF \
--color=marker:#BABBF1,fg+:#C6D0F5,prompt:#CA9EE6,hl+:#E78284 \
--color=selected-bg:#51576D \
--color=border:#737994"
#starship theme
eval "$(starship init zsh)"

test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh" || true
export GOPATH=$HOME/go/
export GOROOT=$(brew --prefix go)/libexec
export PATH=$GOPATH/bin:$GOROOT/bin:$HOME/.local/bin:$PATH

SOFT_SERVE_INITIAL_ADMIN_KEYS=$HOME/.ssh/id_ed25519

# Added by LM Studio CLI (lms)
export PATH="$PATH:/Users/nrd/.lmstudio/bin"
export PATH=/User/nrd:/opt/homebrew/bin:/opt/homebrew/Cellar/fabric/:/Users/nrd/go//bin:/opt/homebrew/opt/go/libexec/bin:/Users/nrd/.local/bin:/Users/nrd/.oh-my-zsh/custom/plugins/git-open:/Users/nrd/bin:/usr/local/bin:/opt/homebrew/bin:/opt/homebrew/bin:/opt/homebrew/sbin:/usr/local/bin:/System/Cryptexes/App/usr/bin:/usr/bin:/bin:/usr/sbin:/sbin:/var/run/com.apple.security.cryptexd/codex.system/bootstrap/usr/local/bin:/var/run/com.apple.security.cryptexd/codex.system/bootstrap/usr/bin:/var/run/com.apple.security.cryptexd/codex.system/bootstrap/usr/appleinternal/bin:/Library/Apple/usr/bin:/Applications/kitty.app/Contents/MacOS:/Users/nrd/.local/bin:/Users/nrd/.lmstudio/bin:/Users/nrd/.nvm/versions/node/v22.17.1/lib/node_modules:$PATH

# Generated for envman. Do not edit.
[ -s "$HOME/.config/envman/load.sh" ] && source "$HOME/.config/envman/load.sh"

eval "$(pkgx --quiet dev --shellcode)"  # https://github.com/pkgxdev/dev

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# pnpm
export PNPM_HOME="/Users/nrd/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end
export PATH=/Applications/*.app/Contents/MacOS/:$PATH

export PATH=~/.local/share/mise/installs/python/3.12.10/lib/python3.12/site-packages:/Users/nrd/Library/pnpm:/Users/nrd/.nvm/versions/node/v24.4.1/bin:/User/nrd:/opt/homebrew/bin:/opt/homebrew/Cellar/fabric/:/Users/nrd/go//bin:/opt/homebrew/opt/go/libexec/bin:/Users/nrd/.local/bin:/Users/nrd/.oh-my-zsh/custom/plugins/git-open:/Users/nrd/bin:/usr/local/bin:/opt/homebrew/bin:/opt/homebrew/bin:/opt/homebrew/sbin:/usr/local/bin:/System/Cryptexes/App/usr/bin:/usr/bin:/bin:/usr/sbin:/sbin:/var/run/com.apple.security.cryptexd/codex.system/bootstrap/usr/local/bin:/var/run/com.apple.security.cryptexd/codex.system/bootstrap/usr/bin:/var/run/com.apple.security.cryptexd/codex.system/bootstrap/usr/appleinternal/bin:/Library/Apple/usr/bin:/Applications/kitty.app/Contents/MacOS:/Users/nrd/.local/bin:/Users/nrd/.lmstudio/bin:/Users/nrd/.nvm/versions/node/v22.17.1/lib/node_modules:/Users/nrd/go//bin:/opt/homebrew/opt/go/libexec/bin:/Users/nrd/.local/bin:/Users/nrd/.local/share/mise/installs/python/3.12/bin:/Users/nrd/.oh-my-zsh/custom/plugins/git-open:/Users/nrd/bin:/usr/local/bin:/opt/homebrew/bin:/opt/homebrew/bin:/opt/homebrew/sbin:/usr/local/bin:/System/Cryptexes/App/usr/bin:/usr/bin:/bin:/usr/sbin:/sbin:/var/run/com.apple.security.cryptexd/codex.system/bootstrap/usr/local/bin:/var/run/com.apple.security.cryptexd/codex.system/bootstrap/usr/bin:/var/run/com.apple.security.cryptexd/codex.system/bootstrap/usr/appleinternal/bin:/Library/Apple/usr/bin:/Applications/iTerm.app/Contents/Resources/utilities:/Users/nrd/.local/bin:/Users/nrd/.lmstudio/bin
export PATH=/Users/nrd/.local/share/mise/installs/python/3.12.10/lib/python3.12/site-packages:/Users/nrd/Library/pnpm:/Users/nrd/.nvm/versions/node/v24.4.1/bin:/User/nrd:/opt/homebrew/bin:/opt/homebrew/Cellar/fabric/:/Users/nrd/go//bin:/opt/homebrew/opt/go/libexec/bin:/Users/nrd/.local/bin:/Users/nrd/.oh-my-zsh/custom/plugins/git-open:/Users/nrd/bin:/usr/local/bin:/opt/homebrew/bin:/opt/homebrew/bin:/opt/homebrew/sbin:/usr/local/bin:/System/Cryptexes/App/usr/bin:/usr/bin:/bin:/usr/sbin:/sbin:/var/run/com.apple.security.cryptexd/codex.system/bootstrap/usr/local/bin:/var/run/com.apple.security.cryptexd/codex.system/bootstrap/usr/bin:/var/run/com.apple.security.cryptexd/codex.system/bootstrap/usr/appleinternal/bin:/Library/Apple/usr/bin:/Applications/kitty.app/Contents/MacOS:/Users/nrd/.local/bin:/Users/nrd/.lmstudio/bin:/Users/nrd/.nvm/versions/node/v22.17.1/lib/node_modules:/Users/nrd/go//bin:/opt/homebrew/opt/go/libexec/bin:/Users/nrd/.local/bin:/Users/nrd/.local/share/mise/installs/python/3.12/bin:/Users/nrd/.oh-my-zsh/custom/plugins/git-open:/Users/nrd/bin:/usr/local/bin:/opt/homebrew/bin:/opt/homebrew/bin:/opt/homebrew/sbin:/usr/local/bin:/System/Cryptexes/App/usr/bin:/usr/bin:/bin:/usr/sbin:/sbin:/var/run/com.apple.security.cryptexd/codex.system/bootstrap/usr/local/bin:/var/run/com.apple.security.cryptexd/codex.system/bootstrap/usr/bin:/var/run/com.apple.security.cryptexd/codex.system/bootstrap/usr/appleinternal/bin:/Library/Apple/usr/bin:/Applications/iTerm.app/Contents/Resources/utilities:/Users/nrd/.local/bin:/Users/nrd/.lmstudio/bin:~/Downloads/GithubApps/quickemu
export PATH=/Users/nrd/.local/share/mise/installs/python/3.12.10/lib/python3.12/site-packages:/Users/nrd/Library/pnpm:/Users/nrd/.nvm/versions/node/v24.4.1/bin:/User/nrd:/opt/homebrew/bin:/opt/homebrew/Cellar/fabric/:/Users/nrd/go//bin:/opt/homebrew/opt/go/libexec/bin:/Users/nrd/.local/bin:/Users/nrd/.oh-my-zsh/custom/plugins/git-open:/Users/nrd/bin:/usr/local/bin:/opt/homebrew/bin:/opt/homebrew/bin:/opt/homebrew/sbin:/usr/local/bin:/System/Cryptexes/App/usr/bin:/usr/bin:/bin:/usr/sbin:/sbin:/var/run/com.apple.security.cryptexd/codex.system/bootstrap/usr/local/bin:/var/run/com.apple.security.cryptexd/codex.system/bootstrap/usr/bin:/var/run/com.apple.security.cryptexd/codex.system/bootstrap/usr/appleinternal/bin:/Library/Apple/usr/bin:/Applications/kitty.app/Contents/MacOS:/Users/nrd/.local/bin:/Users/nrd/.lmstudio/bin:/Users/nrd/.nvm/versions/node/v22.17.1/lib/node_modules:/Users/nrd/go//bin:/opt/homebrew/opt/go/libexec/bin:/Users/nrd/.local/bin:/Users/nrd/.local/share/mise/installs/python/3.12/bin:/Users/nrd/.oh-my-zsh/custom/plugins/git-open:/Users/nrd/bin:/usr/local/bin:/opt/homebrew/bin:/opt/homebrew/bin:/opt/homebrew/sbin:/usr/local/bin:/System/Cryptexes/App/usr/bin:/usr/bin:/bin:/usr/sbin:/sbin:/var/run/com.apple.security.cryptexd/codex.system/bootstrap/usr/local/bin:/var/run/com.apple.security.cryptexd/codex.system/bootstrap/usr/bin:/var/run/com.apple.security.cryptexd/codex.system/bootstrap/usr/appleinternal/bin:/Library/Apple/usr/bin:/Applications/iTerm.app/Contents/Resources/utilities:/Users/nrd/.local/bin:/Users/nrd/.lmstudio/bin:/Users/nrd/Downloads/GithubApps/quickemu:~/quickgui
export PATH=/Users/nrd/.local/share/mise/installs/python/3.12.10/lib/python3.12/site-packages:/Users/nrd/Library/pnpm:/Users/nrd/.nvm/versions/node/v24.4.1/bin:/User/nrd:/opt/homebrew/bin:/opt/homebrew/Cellar/fabric/:/Users/nrd/go//bin:/opt/homebrew/opt/go/libexec/bin:/Users/nrd/.local/bin:/Users/nrd/.oh-my-zsh/custom/plugins/git-open:/Users/nrd/bin:/usr/local/bin:/opt/homebrew/bin:/opt/homebrew/bin:/opt/homebrew/sbin:/usr/local/bin:/System/Cryptexes/App/usr/bin:/usr/bin:/bin:/usr/sbin:/sbin:/var/run/com.apple.security.cryptexd/codex.system/bootstrap/usr/local/bin:/var/run/com.apple.security.cryptexd/codex.system/bootstrap/usr/bin:/var/run/com.apple.security.cryptexd/codex.system/bootstrap/usr/appleinternal/bin:/Library/Apple/usr/bin:/Applications/kitty.app/Contents/MacOS:/Users/nrd/.local/bin:/Users/nrd/.lmstudio/bin:/Users/nrd/.nvm/versions/node/v22.17.1/lib/node_modules:/Users/nrd/go//bin:/opt/homebrew/opt/go/libexec/bin:/Users/nrd/.local/bin:/Users/nrd/.local/share/mise/installs/python/3.12/bin:/Users/nrd/.oh-my-zsh/custom/plugins/git-open:/Users/nrd/bin:/usr/local/bin:/opt/homebrew/bin:/opt/homebrew/bin:/opt/homebrew/sbin:/usr/local/bin:/System/Cryptexes/App/usr/bin:/usr/bin:/bin:/usr/sbin:/sbin:/var/run/com.apple.security.cryptexd/codex.system/bootstrap/usr/local/bin:/var/run/com.apple.security.cryptexd/codex.system/bootstrap/usr/bin:/var/run/com.apple.security.cryptexd/codex.system/bootstrap/usr/appleinternal/bin:/Library/Apple/usr/bin:/Applications/iTerm.app/Contents/Resources/utilities:/Users/nrd/.local/bin:/Users/nrd/.lmstudio/bin:/Users/nrd/Downloads/GithubApps/quickemu:/Users/nrd/quickgui:/Users/nrd/quickgui/build/macos/build/Products/Release/quickgui.app/Contents/MacOS

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
#[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
export PATH=/Users/nrd/.local/share/mise/installs/python/3.12.10/lib/python3.12/site-packages:/Users/nrd/Library/pnpm:/Users/nrd/.nvm/versions/node/v24.4.1/bin:/User/nrd:/opt/homebrew/bin:/opt/homebrew/Cellar/fabric/:/Users/nrd/go//bin:/opt/homebrew/opt/go/libexec/bin:/Users/nrd/.local/bin:/Users/nrd/.oh-my-zsh/custom/plugins/git-open:/Users/nrd/bin:/usr/local/bin:/opt/homebrew/bin:/opt/homebrew/bin:/opt/homebrew/sbin:/usr/local/bin:/System/Cryptexes/App/usr/bin:/usr/bin:/bin:/usr/sbin:/sbin:/var/run/com.apple.security.cryptexd/codex.system/bootstrap/usr/local/bin:/var/run/com.apple.security.cryptexd/codex.system/bootstrap/usr/bin:/var/run/com.apple.security.cryptexd/codex.system/bootstrap/usr/appleinternal/bin:/Library/Apple/usr/bin:/Applications/kitty.app/Contents/MacOS:/Users/nrd/.local/bin:/Users/nrd/.lmstudio/bin:/Users/nrd/.nvm/versions/node/v22.17.1/lib/node_modules:/Users/nrd/go//bin:/opt/homebrew/opt/go/libexec/bin:/Users/nrd/.local/bin:/Users/nrd/.oh-my-zsh/custom/plugins/git-open:/Users/nrd/bin:/usr/local/bin:/opt/homebrew/bin:/opt/homebrew/bin:/opt/homebrew/sbin:/usr/local/bin:/System/Cryptexes/App/usr/bin:/usr/bin:/bin:/usr/sbin:/sbin:/var/run/com.apple.security.cryptexd/codex.system/bootstrap/usr/local/bin:/var/run/com.apple.security.cryptexd/codex.system/bootstrap/usr/bin:/var/run/com.apple.security.cryptexd/codex.system/bootstrap/usr/appleinternal/bin:/Library/Apple/usr/bin:/Applications/iTerm.app/Contents/Resources/utilities:/Users/nrd/.local/bin:/Users/nrd/.lmstudio/bin:/Users/nrd/Downloads/GithubApps/quickemu:/Users/nrd/quickgui:/Users/nrd/quickgui/build/macos/build/Products/Release/quickgui.app/Contents/MacOS:/nix/var/nix/profiles/default/bin:/nix/store/0mbhwi1461n52jv98zqd40id44j2v6h4-darwin-rebuild/bin

# Added by Windsurf
# jkk
export PATH="$HOME/.nix-profile/bin:/Users/nrd/.codeium/windsurf/bin:/opt/metasploit-framework/bin:$PATH"
export PATH="$(brew --prefix)/opt/python@3.11/libexec/bin:$PATH"
#export MANPAGER="sh -c 'awk '\''{ gsub(/\x1B\[[0-9;]*m/, \"\", \$0); gsub(/.\x08/, \"\", \$0); print }'\'' | bat -lman --color=always'"
export MANPAGER='nvim +Man!'
export BAT_THEME="Catppuccin Frappe"
export BAT_STYLE="full"
alias cat="bat --decorations always --color always"
export DELTA_FEATURES=+side-by-side
export EZA_CONFIG_DIR='/Users/nrd/.config/eza'
export NIXPKGS_ALLOW_UNFREE=1
function y() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
	yazi "$@" --cwd-file="$tmp"
	IFS= read -r -d '' cwd < "$tmp"
	[ -n "$cwd" ] && [ "$cwd" != "$PWD" ] && builtin cd -- "$cwd"
	rm -f -- "$tmp"
}

# opencode
export PATH=/Users/nrd/.opencode/bin:/Users/nrd/.config/nix/result/sw/bin:$PATH
