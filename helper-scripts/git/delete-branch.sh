#!/bin/bash

set -e
script_dir=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd)
source "${script_dir}/git-library.sh"
validate_current_directory_is_clean_git_root
core_branch="$(current_branch)"

default_branches=(
develop
master
main
"$(git branch | sed 's/[\* ]//g' | grep -Po '^(?!'"${core_branch}"').+$' | head -n 1)"
)

confirm() {
  read -p 'Accept or ctrl-C >'
}

checkout_default_branch() {
  local branch
  for branch in "${default_branches[@]}"; do
    if mute git checkout "${branch}"; then
      return 0
    fi
  done
}

case "${core_branch}" in
  master|develop)
  echo "Will not delete ${core_branch}"
  exit 2
  ;;
esac

(
  git fetch
  git merge || true
  echo "✨ Recovery hash $(git rev-parse "${core_branch}")"
) 1>_temp_delete_log 2>&1 &

echo "Delete local and remote branch ${core_branch}?"
confirm
wait
cat _temp_delete_log
rm _temp_delete_log

git push origin :"${core_branch}" || true
checkout_default_branch
git merge
git branch -D "${core_branch}"

