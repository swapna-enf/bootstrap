#Git related aliases

export K7_TRUE_ORIGIN=origin
export GIT_EDITOR=vim
#export K7_TRUE_ORIGIN=upstream
alias gst='git status'
alias gbr='git branch'

alias glg='git log'
alias gla='git log --author '

alias gco='git checkout '
alias gcm='git checkout master'

alias gpr='git pull --rebase '
#alias gprom='git pull --rebase $K7_TRUE_ORIGIN master'
#alias gfo='git fetch $K7_TRUE_ORIGIN'

setup_upstream () {
    echo "=============="
    echo "Current remote"
    echo "=============="
    git remote -vv
    echo ""
    echo "=============="
    echo "Setup Upstream"
    echo "=============="
    CMD="git remote add upstream git@github.com:witesand/${PWD##*/}.git"
    echo $CMD
    $CMD
    echo ""
    echo "=============="
    echo "Updated remote"
    echo "=============="
    git remote -vv
    echo ""
}

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

gcot () {
    if [ $# -lt 2 ]; then
        echo "${FUNCNAME[0]} requires 2 arg <tag> <branch>"
        return 1;
    else
		CMD="git checkout tags/$1 -B $2"
		echo $CMD
		$CMD
	fi
}

gcopr () {
    if [ $# -lt 2 ]; then
        echo "${FUNCNAME[0]} requires 2 arg <PR> <NEWBRANCH>"
        return 1;
    else
		CMD="git fetch upstream pull/$1/head:$2"
		echo $CMD
		$CMD
	fi
}
