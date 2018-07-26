#!/bin/bash

scripts_dir=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd)

usage() {
	echo "usage: $(basename $0) <elspleth machine directory>"
	echo "choices:"
	ls "${scripts_dir}/.."
	echo "note that common_machine is processed in addition to choice"
	exit 1
}

if [ $# -ne 1 ]; then
	usage
fi

specific_machine=$(realpath "${scripts_dir}/../$1")
specific_home="${specific_machine}/home"
common_machine=$(realpath "${scripts_dir}/../common_machine")
common_home="${common_machine}/home"

expected_dirs=("${specific_machine}" "${specific_home}" "${common_machine}" "${common_home}")

for i in "${expected_dirs[@]}"; do
	if [ ! -d "${i}" ]; then
		echo "Directory does not exist: ${i}"
		exit -1
	fi
done

# variable number of files under version control
hardlink_to_version_control() {
	for i in "$@"; do
		if [ -f "$i" ]; then
			local versioned="$i"
			local valuable=~/$(basename "$i")
			printf "%-80s to ${valuable}\n" "Relinking ${versioned}"
			rm "${versioned}"
			ln "${valuable}" "${versioned}"
		fi
	done
}

hardlink_to_version_control "${common_home}"/.*
hardlink_to_version_control "${common_home}"/*
hardlink_to_version_control "${specific_home}"/.*
hardlink_to_version_control "${specific_home}"/*

