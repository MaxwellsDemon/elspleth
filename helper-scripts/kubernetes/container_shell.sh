#!/bin/bash

if [ $# -lt 1 -o $# -gt 2 ];then
    echo "usage: $(basename "$0") <pod name substring> [<container name>]"
    exit 1
fi
container_name="$1"
if [ "$2" ]; then
	container_name="$2"
fi
pod_name=$(kubectl get pods | grep "$1" | cut -f1 -d' ')
kubectl exec -it "${pod_name}" -c "${container_name}" -- sh

