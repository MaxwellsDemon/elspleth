#!/bin/bash

# ###################
# Source this script
# ###################

if [ $# -lt 1 -o $# -gt 2 ];then
    echo "usage: $(basename "$0") <pod name substring> [<container name>]"
    exit 1
fi
container_name="$1"
if [ "$2" ]; then
	container_name="$2"
fi
pod_info=$(kubectl get pods --all-namespaces | grep "$1" | sed -E 's/ +/ /g')
namespace=$(echo "${pod_info}" | cut -f1 -d' ')
pod_name=$(echo "${pod_info}" | cut -f2 -d' ')
echo "pod: ${pod_name}"
echo "container: ${container_name}"
echo "namespace: ${namespace}"

