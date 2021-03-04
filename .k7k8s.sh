echo "Loading k8s"

kk() {
	kubectl "${@:1}"
}

