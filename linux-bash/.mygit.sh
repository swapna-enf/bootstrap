#Git related aliases

export _MY_TRUE_ORIGIN=origin
export GIT_EDITOR=vim
#export _MY_TRUE_ORIGIN=upstream
alias gst='git status'
alias gbr='git branch'

alias glg='git log'
alias gla='git log --author '

alias gco='git checkout '
alias gcm='git checkout ${GITMAIN}'

alias gpr='git pull --rebase '
#alias gprom='git pull --rebase $_MY_TRUE_ORIGIN ${GITMAIN}'
#alias gfo='git fetch $_MY_TRUE_ORIGIN'

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
        CMD="git pull --rebase $_MY_TRUE_ORIGIN ${GITMAIN}"
    else
        CMD="git pull --rebase $1 ${GITMAIN}"
    fi;
    echo $CMD
    $CMD
}

gfo () {
    if [ $# -lt 1 ]; then
        CMD="git fetch $_MY_TRUE_ORIGIN"
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

dkrdeploy ()
{
    if [ $# -lt 2 ]; then
        echo "${FUNCNAME[0]} requires 2 args <tag> <docker>";
        return 1;
    else
		if [ -z $DKRREG ]; then
			echo 'Set DKRREG docker registry'
			return 1;
		fi
        CMD="docker tag $2 ${DKRREG}/$2:$1 && docker push ${DKRREG}/$2:$1";
        echo $CMD;
        docker tag $2 ${DKRREG}/$2:$1 && docker push ${DKRREG}/$2:$1;
    fi
}
