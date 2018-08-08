#!/bin/bash

if [ $# -ne 1 ]; then
    echo "usage: $(basename "$0") <pod name substring>"
    exit 1
fi

scripts_dir=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd)
source "${scripts_dir}"/k8s_library.sh

get_pod_info $1

echo -n "containers: "
kubectl get pods "${pod_name}" -n "${namespace}" -o jsonpath='{.spec.containers[*].name}'
echo

