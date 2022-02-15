echo "Loading k8s"

alias k=kubectl
kk() {
    if [ -z "KUBECTLCMD" ]; then
        _KUBECTLCMD=kubectl
    else
        _KUBECTLCMD=$KUBECTLCMD
    fi
    _CMD=$_KUBECTLCMD "${@:1}"
    echo $_CMD
    $_CMD
}

delpod() {
    _kPOD=`k get pods|grep ${1}|awk '{print $1}'`
    k delete pod ${_kPOD}
    getpods
}

showlogs() {
    _kPOD=`k get pods|grep ${1}|grep Runnin|awk '{print $1}'`
    if [ -z $2 ]; then
        k logs -f ${_kPOD}
    else
        k logs -f ${_kPOD} -c $2
    fi
}

kshell() {
    _kPOD=`k get pods|grep ${1}|grep Runnin|awk '{print $1}'`
    if [ -z $2 ]; then
        k exec -it ${_kPOD} -- /bin/sh
    else
        k exec -it ${_kPOD} -c $2 -- /bin/sh
    fi
}
