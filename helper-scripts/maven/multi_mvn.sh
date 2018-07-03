#!/bin/bash

# Location of this file
scripts_dir=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd)

# ===== Custom variables ======================================================================

# Detect mvn projects relative to current directory
root_dir="."

# Detect mvn projects relative to this script
# root_dir="${scripts_dir}"

# =============================================================================================

root_dir=$(realpath "${root_dir}")

# Usage
if [[ $# -eq 0 ]]; then
	echo "Runs a mvn command in each directory containing pom.xml in any subdirectory of ${root_dir}"
	exit 1
fi

if [ "${TRAVERSAL}" = deep ]; then
	find_opts=''
elif [ "${TRAVERSAL}" = shallow ]; then
	find_opts='-maxdepth 2'
else
	echo "Set variable TRAVERSAL to either 'shallow' or 'deep'"
	exit 2
fi

# Find mvn projects
project_paths=()
for mvn_dir in $(find "${root_dir}" $find_opts -name pom.xml | sort)
do
	project_path=$(realpath $(dirname "${mvn_dir}"))
	cd "${project_path}"
	project=$(basename "${project_path}")

	# 93 Yellow
	echo
	echo -e "\x1B[93m${project}\x1B[0m"
	echo
	mvn "$@"
done

echo "All Maven done."
