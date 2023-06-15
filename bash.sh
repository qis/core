# Files
umask 0022

# Limits
ulimit -S -c 0

# Unicode
export NCURSES_NO_UTF8_ACS="1"
export MM_CHARSET="UTF-8"

# Localization
export LC_COLLATE=C.UTF-8
export LC_MESSAGES=C.UTF-8
export LC_NUMERIC=C.UTF-8

# Applications
export EDITOR="vim"
export PAGER="less"
export LESS="-iqFR --no-vbell"

export XZ_OPT="-T16"

# Colors
export LS_COLORS="di=1;34:ln=1;36:so=1;35:pi=33:ex=1;32:bd=1;33:cd=1;33:su=1;31:sg=1;30;41:tw=1;31:ow=1;35"

# Aliases
alias ..="cd .."

alias ls="ls -v --color=auto --group-directories-first --time-style=long-iso"
alias ll="ls -lh"
alias lsa="ls -A"
alias lla="ll -A"

alias tm="tmux -2"
alias ta="tm attach -t"
alias ts="tm new-session -s"
alias tl="tm list-sessions"

alias mime="file --mime-type -b"
alias diff="diff --color=auto"
alias grep="grep --color=auto"
alias sudo="sudo "

# Settings
export HISTFILE="${HOME}/.history"
export HISTCONTROL="ignoreboth:erasedups"
shopt -s histappend

tp() {
  if [ -n "${TMUX}" ]; then
    id="$(echo $TMUX | awk -F, '{print $3 + 1}')"
    session="$(tmux ls | head -${id} | tail -1 | cut -d: -f1)"
    echo -e "\e[90m[\e[0m${session}\e[90m]\e[0m "
  fi
}

if [ $(id -u) -ne 0 ]; then
  export PS1='$(tp)\[\e[32m\]\u\[\e[0m\]@\[\e[32m\]\h\[\e[0m\] \[\e[34m\]\w\[\e[0m\] '
else
  export PS1='$(tp)\[\e[31m\]\u\[\e[0m\]@\[\e[32m\]\h\[\e[0m\] \[\e[34m\]\w\[\e[0m\] '
fi

if [[ $- == *i* ]]; then
  set -o emacs
  stty werase '^_'
  bind '"\C-H":backward-kill-word'
  bind '"\e[Z":menu-complete-backward'
fi
