#!/bin/bash

set -e
script_dir=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd)
source "${script_dir}/git_library.sh"

confirm() {
  read -p 'Accept or ctrl-C >'
}

validate_current_directory_is_clean_git_root

core_branch="$(current_branch)"
case "${core_branch}" in
  master|develop)
  echo "Will not delete ${core_branch}"
  exit 2
  ;;
esac

echo "Delete local and remote branch ${core_branch}?"
confirm

git push origin :"${core_branch}" || true
checkout_develop_or_master
if ! git branch -d "${core_branch}" ; then
  confirm
  git branch -D "${core_branch}"
fi

