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



# Find mvn projects
project_paths=()
# Shallow and fast maxdepth=2 search
for mvn_dir in $(find "${root_dir}" -name pom.xml | sort)
do
	project_path=$(realpath $(dirname "${mvn_dir}"))
	cd "${project_path}"
	project=$(basename "${project_path}")

	# 93 Yellow
	echo
	echo -e "\e[93m${project}\e[0m"
	echo
	mvn "$@"
done

echo "All Maven done."
