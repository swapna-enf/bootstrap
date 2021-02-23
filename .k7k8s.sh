echo "Loading k8s"

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

