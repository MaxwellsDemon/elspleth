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

# For each versioned file in args $2 and after, overwrite it from directory $1.
gather_to_version_control() {
	local exotic_directory="$1"
	shift 1
	for i in "$@"; do
		if [ -f "$i" ]; then
			local versioned="$i"
			local valuable="${exotic_directory}"/$(basename "$i")
			printf "%-60s to ${versioned}\n" "Copied ${valuable}"
			rm "${versioned}"
			cp "${valuable}" "${versioned}"
		fi
	done
}

gather_to_version_control ~ "${common_home}"/.* "${common_home}"/*
gather_to_version_control ~ "${specific_home}"/.* "${specific_home}"/*

# Not appropriate for github
#gather_to_version_control /etc "${specific_machine}"/hosts

