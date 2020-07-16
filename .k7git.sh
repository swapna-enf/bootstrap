#Git related aliases

alias gst='git status'
alias gbr='git branch'

alias glg='git log'
alias gla='git log --author '

alias gco='git checkout '
alias gcm='git checkout master'

alias gpr='git pull --rebase '

export K7_TRUE_ORIGIN=origin
gprom () {
    if [ $# -lt 1 ]; then
        CMD="git pull --rebase $K7_TRUE_ORIGIN master"
    else
        CMD="git pull --rebase $1 master"
    fi;
    echo $CMD
    $CMD
}

gfo () {
    if [ $# -lt 1 ]; then
        CMD="git fetch $K7_TRUE_ORIGIN"
    else
        CMD="git fetch $1"
    fi;
    echo $CMD
    $CMD
}
