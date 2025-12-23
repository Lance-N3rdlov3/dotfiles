#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias grep='grep --color=auto'
PS1='[\u@\h \W]\$ '


# Added by LM Studio CLI (lms)
export PATH="$PATH:/Users/nrd/.lmstudio/bin"

# Generated for envman. Do not edit.
[ -s "$HOME/.config/envman/load.sh" ] && source "$HOME/.config/envman/load.sh"

eval "$(pkgx --quiet dev --shellcode)"  # https://github.com/pkgxdev/dev
