#!/bin/bash

trap ctrl_c INT

scripts_dir=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd)
source "${scripts_dir}/pod_and_container_command.sh"

function ctrl_c() {
	echo
	echo
	echo "Use this command to get the entire logs"
	echo "kubectl logs -n \"${namespace}\" \"${pod_name}\" -c \"${container_name}\" > \"${container_name}\".log"
	echo
}

kubectl logs -n "${namespace}" -f "${pod_name}" -c "${container_name}"

