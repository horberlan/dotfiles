#!/usr/bin/env zsh
 
 on-cd $({{
    source /usr/share/git/completion/git-prompt.sh
    GIT_PS1_SHOWDIRTYSTATE=auto
    GIT_PS1_SHOWSTASHSTATE=auto
    GIT_PS1_SHOWUNTRACKEDFILES=auto
    GIT_PS1_SHOWUPSTREAM=auto
    GIT_PS1_COMPRESSSPARSESTATE=auto
    git=$(__git_ps1 " [GIT BRANCH:> %s]") || true
    fmt="\033[32;1m%u@%h\033[0m:\033[34;1m%w\033[0m\033[33;1m$git\033[0m"
    lf -remote "send $id set promptfmt \"$fmt\""
}})