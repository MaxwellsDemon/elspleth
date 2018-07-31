#!/bin/bash
scripts_dir=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd)
source "${scripts_dir}/pod_and_container_command.sh"
kubectl logs -n "${namespace}" "${pod_name}" -c "${container_name}" > "${container_name}".log
kubectl logs -n "${namespace}" -f "${pod_name}" -c "${container_name}"

