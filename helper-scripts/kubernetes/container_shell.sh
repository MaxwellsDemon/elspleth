#!/bin/bash
scripts_dir=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd)
source "${scripts_dir}/pod_and_container_command.sh"
echo "kubectl exec -n '${namespace}' -it '${pod_name}' -c '${container_name}' -- /bin/bash"
kubectl exec -n "${namespace}" -it "${pod_name}" -c "${container_name}" -- /bin/bash

