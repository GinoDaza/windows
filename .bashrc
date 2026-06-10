# ubuntu-wsl

# =====================================================================
# SYSTEM CORE & INTERACTIVE SESSION
# =====================================================================
case $- in
    *i*) ;;
      *) return;;
esac

if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# =====================================================================
# TERMINAL HISTORY & WINDOW SETTINGS
# =====================================================================
HISTCONTROL=ignoreboth
shopt -s histappend
HISTSIZE=1000
HISTFILESIZE=2000
shopt -s checkwinsize

# =====================================================================
# ENVIRONMENT PATHS
# =====================================================================
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"
export PATH="$HOME/.local/bin:$PATH"

# =====================================================================
# CUSTOM PROMPT & DISPAYS
# =====================================================================
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
        color_prompt=yes
    else
        color_prompt=
    fi
fi

unset color_prompt force_color_prompt

PS1='\[\e]0;\u: \w\a\]${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '

# =====================================================================
# SYSTEM ALIASES
# =====================================================================
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# =====================================================================
# USER CUSTOM ALIASES & FUNCTIONS
# =====================================================================
alias vim='nvim'
alias work='cd /mnt/c/Users/ginoD/Desktop/workpool-back'
alias cdd='cd /mnt/c/Users/ginoD/Desktop'

cds() {
  cd "$1" && ls
}
