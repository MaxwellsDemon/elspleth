#!/bin/bash
set -e

if [ $# -ne 1 ]; then
    echo "usage: $(basename "$0") <pod name substring>"
    exit 1
fi
pod_info=$(kubectl get pods --all-namespaces | grep "$1" | sed -E 's/ +/ /g')
namespace=$(echo "${pod_info}" | cut -f1 -d' ')
pod_name=$(echo "${pod_info}" | cut -f2 -d' ')
echo "pod: ${pod_name}"
echo "namespace: ${namespace}"
echo -n "containers: "
kubectl get pods "${pod_name}" -n "${namespace}" -o jsonpath='{.spec.containers[*].name}'
echo

