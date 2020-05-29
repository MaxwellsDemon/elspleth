#!/bin/bash
set -e

src_branch="$1"
base_branch="$2"
squash_branch="squashed_branch"

usage() {
  echo "usage: $(basename $0) <branch to squash> <base branch>"
  echo
  echo "First arg is your feature branch. Second arg is usually develop branch."
  echo "Commits in feature branch up to and excluding the base branch are replaced with one commit."
  echo
  echo "Will prompt to write the real commit message."
  echo
  echo "Local branches:"
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
src_branch_hash="$(git rev-parse HEAD)"
git checkout "${base_branch}"

section "Updating ${base_branch}"
git checkout "${base_branch}"
git pull || :

section "Rebasing ${src_branch}"
git checkout "${src_branch}"
git rebase "${base_branch}"

section "Squashing"
git checkout "${base_branch}"
git checkout -b "${squash_branch}"
git merge --squash "${src_branch}"
git commit

section "Propagating squash"
git checkout "${squash_branch}"
git branch -D "${src_branch}"
git checkout -b "${src_branch}"
git push --set-upstream origin +"${src_branch}"
git branch -d "${squash_branch}"

section "Review local branches"
git branch

echo -e "\n⇒ If you want to restore, here is the hash of ${src_branch} branch before rebase or squash: ${src_branch_hash}"

