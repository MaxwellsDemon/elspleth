#!/bin/bash
set -e

scripts_dir=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd)
source "${scripts_dir}/pod_and_container_command.sh"

echo
echo "PICK YOUR POISON"
echo
echo "MAY NEVER FINISH"
echo "kubectl logs -n \"${namespace}\" \"${pod_name}\" -c \"${container_name}\" > \"${container_name}\".log && vi \"${container_name}\".log"
echo
echo "LAST 1000 LINES"
echo "kubectl logs -n \"${namespace}\" --tail=1000 \"${pod_name}\" -c \"${container_name}\" > \"${container_name}\".log && vi \"${container_name}\".log"

