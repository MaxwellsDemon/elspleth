#!/bin/bash

if [ $# -ne 1 ]; then
    echo "usage: $(basename "$0") <pod name substring>"
    exit 1
fi

scripts_dir=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd)
source "${scripts_dir}"/k8s_library.sh

pod_base_name=$1
function get_pod_info() {
    kubectl get $@ pods 2> /dev/null | grep "${pod_base_name}" | sed -E 's/ +/ /g'
}

# Deal with lack of permissions for all ns
pod_info=$(get_pod_info --all-namespaces)
if [ "${pod_info}" ]; then
    namespace=$(echo "${pod_info}" | cut -f1 -d' ')
    pod_name=$(echo "${pod_info}" | cut -f2 -d' ')
else
    namespace=$(get_current_namespace)
    pod_info=$(get_pod_info -n "${namespace}")
    pod_name=$(echo "${pod_info}" | cut -f1 -d' ')
fi

echo "pod: ${pod_name}"
echo "namespace: ${namespace}"
echo -n "containers: "
kubectl get pods "${pod_name}" -n "${namespace}" -o jsonpath='{.spec.containers[*].name}'
echo

