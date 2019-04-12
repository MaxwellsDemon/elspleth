#!/bin/bash
set -e

src_branch="$1"
base_branch="$2"
squash_branch="squashed_branch"
src_backup_branch="squash_src_backup"

usage() {
  echo "usage: $(basename $0) <branch to squash> <base branch>"
  echo "Overwrites branch to squash with new commit and force pushes change"
  echo
  git branch
  exit 1
}

section() {
  echo
  echo -e "\x1B[93m$1\x1B[0m"
  echo
}

if [ $# -ne 2 ]; then
  usage
fi
if [ "${src_branch}" = develop ] || [ "${src_branch}" = master ]; then
  echo "Will not squash develop or master"
  exit 2
fi
if [ ! -d .git ]; then
  echo "Please change to root Git project directory"
  exit -22
fi
if [ -n "$(git status --porcelain)" ]; then
  echo "Please clean Git workspace for $(basename $(pwd))"
  exit -33
fi

section "Testing for typos"
git checkout "${src_branch}"
git checkout "${base_branch}"

section "Updating ${base_branch}"
git checkout "${base_branch}"
git pull || :

section "Rebasing ${src_branch}"
git checkout "${src_branch}"
git rebase "${base_branch}"

section "Backing up ${src_branch}"
git checkout "${src_branch}"
git push
git checkout -b "${src_backup_branch}"

section "Squashing"
git checkout "${base_branch}"
git checkout -b "${squash_branch}"
git merge --squash "${src_branch}"
git commit

section "Propagating squash"
git checkout "${squash_branch}"
git branch -d "${src_branch}"
git checkout -b "${src_branch}"
git push --set-upstream origin +"${src_branch}"
git branch -d "${squash_branch}"

section "Deleting local branch backup"
git branch -D "${src_backup_branch}"

section "Review local branches"
git branch

echo "Script done."

