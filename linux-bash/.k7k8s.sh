echo "Loading k8s"

alias ks="k -n kube-system"

kk () {
    if [ $# -lt 1 ]; then
        echo "${FUNCNAME[0]} requires 1 arg <conf>"
        return 1;
    else
        kubectl --kubeconfig=/home/kesavankm/.kube/${1} "${@:2}";
    fi;
}

getpods() {
    if [ $# -lt 1 ]; then
        echo "${FUNCNAME[0]} requires 1 arg <conf>"
        return 1;
    fi;
    _TGT=${1}
	export kAPI=`kk ${_TGT} get pods |grep api|awk '{print $1}'`
	export kLOC=`kk ${_TGT} get pods |grep locus|awk '{print $1}'`
	export kLENS=`kk ${_TGT} get pods |grep lens|awk '{print $1}'`
	export kCampus=`kk ${_TGT} get pods |grep campus|awk '{print $1}'`
}

delpod() {
    if [ $# -lt 2 ]; then
        echo "${FUNCNAME[0]} requires 2 args <TGT_Cluster> <pod>"
        return 1;
    fi;
    _TGT=${1}
    _POD=${2}
	_kPOD=`kk ${_TGT} get pods|grep ${_POD}|awk '{print $1}'`
	kk ${_TGT} delete pod ${_kPOD}
	getpods ${_TGT}
}

delpod() {
    _kPOD=`k get pods|grep ${1}|awk '{print $1}'`
    k delete pod ${_kPOD}
    getpods
}

showlogs() {
    if [ $# -lt 2 ]; then
        echo "${FUNCNAME[0]} requires 2 args <TGT_Cluster> <pod>"
        return 1;
    fi;
    _TGT=${1}
    _POD=${2}
	_kPOD=`kk ${_TGT} get pods|grep ${_POD}|awk '{print $1}'`

	if [ -z ${3} ]; then
		kk ${_TGT} logs -f ${_kPOD}
	else
        _CONT=${3}
		kk ${_TGT} logs -f ${_kPOD} -c ${_CONT}
	fi
}

kshell() {
    if [ $# -lt 2 ]; then
        echo "${FUNCNAME[0]} requires 2 args <TGT_Cluster> <pod> [container]"
        return 1;
    fi;
    if [ -z $KSH ]; then
        KSH=/bin/sh
    fi
    _TGT=${1}
    _POD=${2}
	_kPOD=`kk ${_TGT} get pods|grep ${_POD}|awk '{print $1}'`
	if [ -z $3 ]; then
		kk ${_TGT} exec -it ${_kPOD} -- ${KSH}
	else
        _CONT=${3}
		kk ${_TGT} exec -it ${_kPOD} -c ${_CONT} -- ${KSH}
	fi
}
