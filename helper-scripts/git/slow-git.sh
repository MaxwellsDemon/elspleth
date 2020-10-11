#!/bin/bash

async_batch_size=15
async_batch_sleep_seconds=2

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
  if [ $QUICK = 'STAGGERED' ]; then
    echo "Quick: staggered async git commands"
  else
    echo "Quick: async git commands"
  fi
  # Setup temp directory
  tmp=$(realpath .)
  tmp="${tmp}/_all-git-tmp"
  rm -rf "${tmp}"
  mkdir "${tmp}"
else
  echo "Slow: synchronous git commands"
fi

# 1. project path
tmp_of() {
  echo "${tmp}/$(echo "$1" | sed -E 's,/,__,g')"
}

# Location of this file
script_dir=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd)


# Find Git projects
project_paths=()

# Detect git projects relative to current directory
root_dir="."
git_repos=($( find -E "${root_dir}" \
-name .svn -type d -prune -o \
-name .idea -type d -prune -o \
-name target -type d -prune -o \
-name node_modules -type d -prune -o \
-name .git -type d -print -prune | sort ))

for git_dir in "${git_repos[@]}"
do
  _nice_path="$(dirname "${git_dir}")"
  project_paths+=("${_nice_path#./}")
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
  if [ -z "$(git -C "${project_path}" status --porcelain)" ]
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
  for i in "${!project_paths[@]}"
  do
    project_path="${project_paths[$i]}"
    git -C "${project_path}" -c color.status=always "$@" > "$(tmp_of "${project_path}")" 2>&1 &
    if [ $QUICK = 'STAGGERED' ]; then
      batch_count=$(($i % $async_batch_size))
      if [ ${batch_count} -eq 0 ]; then
        sleep $async_batch_sleep_seconds
      fi
    fi
  done
  wait
fi

# CLEAN PROJECTS
for project_path in "${clean[@]}"
do
  # 93 Yellow
  echo
  echo -e "\x1B[93m${project_path}\x1B[0m"
  echo
  if [ $QUICK ]
  then
    cat "$(tmp_of "${project_path}")"
  else
    git -C "${project_path}" "$@"
  fi
done

# DIRTY PROJECTS
for i in "${!dirty[@]}"
do
  pos=$(expr $i + 1)
  project_path="${dirty[$i]}"
  # 93 Yellow
  echo
  echo -e "\x1B[93m${project_path} [$pos/${#dirty[@]} dirty]\x1B[0m"
  echo
  if [ $QUICK ]
  then
    cat "$(tmp_of "${project_path}")"
  else
    git -C "${project_path}" "$@"
  fi
done

popd > /dev/null

if [ $QUICK ]
then
  rm -rf "${tmp}"
fi

