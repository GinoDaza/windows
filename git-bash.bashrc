# git-bash

parse_git_branch() {
     git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1)/'
}

export PS1='\[\e]0;\u: \w\a\]${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u\[\033[00m\]:\[\033[01;34m\]\w\[\033[01;33m\]$(parse_git_branch)\[\033[00m\]\$ '

alias ls='ls --color=auto'

alias grep='grep --color=auto'

alias ll='ls -alF'

alias la='ls -A'

alias l='ls -CF'

alias cdd='cd ~/Desktop'

cds() {
  cd "$1" && ls
}
