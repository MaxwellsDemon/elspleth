#!/bin/bash

# Assumes a default namespace for kubectl is set in ~/.kube/config

if [ $# -ne 1 ];then
    echo "usage: $(basename "$0") <container name>"
    exit 1
fi

container_name="$1"
pod_name=$(kubectl get pods | grep "$1" | cut -f1 -d' ')

kubectl logs "${pod_name}" -c "${container_name}" > "${container_name}".log
kubectl logs -f "${pod_name}" -c "${container_name}"


