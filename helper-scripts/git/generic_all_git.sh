#!/bin/bash


# Exit on any failures
set -e

# Remember current directory
pushd . > /dev/null

# Usage
if [[ $# -eq 0 ]]; then
	echo 'Runs a git command for each git-enabled repository next to the script. Runs command first against clean repositories, then the dirty ones, according to git status.'
	exit 1
fi

if [ $QUICK ]
then
	# Setup temp directory
	tmp=$(realpath .)
	tmp="${tmp}/all-git-tmp"
	rm -rf "${tmp}"
	mkdir "${tmp}"
fi


# Location of this file
scripts_dir=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd)

# ===== Custom variables ======================================================================

# Detect git projects relative to current directory
root_dir="."

# Detect Git projects relative to this script
# root_dir="${scripts_dir}"

# =============================================================================================

root_dir=$(realpath "${root_dir}")


# Find Git projects
project_paths=()
# Shallow and fast maxdepth=2 search
for git_dir in $(find "${root_dir}" -maxdepth 2 -type d -name .git | sort)
do
	project_path=$(realpath "${git_dir}/..")
	project_paths+=("${project_path}")
done

if [ "${#project_paths[@]}" = 0 ]
then
	echo "No Git projects directly in ${root_dir}"
	exit 0
fi

# Contains project paths
dirty=()
clean=()

for project_path in "${project_paths[@]}"
do
	if [ -z "$(cd "${project_path}"; git status --porcelain)" ]
	then
		# echo "Found clean project ${project_path}"
		clean+=("${project_path}")
	else
		# echo "Found dirty project ${project_path}"
		dirty+=("${project_path}")
	fi
done

if [ $QUICK ]
then
	# Async perform things
	for project_path in "${project_paths[@]}"
	do
		project=$(basename "${project_path}")
		cd "${project_path}"
		git -c color.status=always "$@" > "${tmp}/${project}" 2>&1 &
	done
	wait
fi

# CLEAN PROJECTS
for project_path in "${clean[@]}"
do
	project=$(basename "${project_path}")
	cd "${project_path}"
	# 93 Yellow
	echo
	echo -e "\x1B[93m${project}\x1B[0m"
	echo
	if [ $QUICK ]
	then
		cat "${tmp}/${project}"
	else
		git "$@"
	fi
done

# DIRTY PROJECTS
for i in "${!dirty[@]}"
do
	pos=$(expr $i + 1)
	project_path="${dirty[$i]}"
	project=$(basename "${project_path}")

	cd "${project_path}"

	# 93 Yellow
	echo
	echo -e "\x1B[93m${project} [$pos/${#dirty[@]} dirty]\x1B[0m"
	echo
	if [ $QUICK ]
	then
		cat "${tmp}/${project}"
	else
		git "$@"
	fi
done

popd > /dev/null

if [ $QUICK ]
then
	rm -rf "${tmp}"
fi
