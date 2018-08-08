#!/bin/bash

# ###################
# Source this script
# ###################

if [ $# -lt 1 -o $# -gt 2 ];then
    echo "usage: $(basename "$0") <pod name substring> [<container name>]"
    exit 1
fi
scripts_dir=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd)
source "${scripts_dir}"/k8s_library.sh

container_name="$1"
if [ "$2" ]; then
	container_name="$2"
fi

get_pod_info $1

echo "container: ${container_name}"

