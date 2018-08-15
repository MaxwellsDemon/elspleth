#!/bin/bash

set -e
branch_name="$1"

function usage() {
	echo "usage: $(basename $0) <destination branch name>"
	echo "  Does: stash, a smart pull and checkout/create branch, stash pop, add all, status/diff, commit, push"
	exit 1
}

# Run arbitrary command quietly
function mute() {
	"$@" 2> /dev/null 1>&2
}

function branch_exists() {
	return $(git branch | grep " $1\$" 1> /dev/null 2>&1)
}

function git_pull() {
	echo "Git pull..."
	if mute git pull ; then
		echo "Git pull done"
	else
		echo "Pull didn't happen"
	fi
}

if [ $# -ne 1 ]; then
	usage
fi
if [ ! -d .git ]; then
	echo "Change to root Git project directory"
	exit 2
fi

# ---------- validation done ---------------------------------------------------

mute git add --all .
mute git stash

# FYI
# git checkout returns 0 if already on branch
# git checkout returns 128 if branch already exists

if branch_exists "${branch_name}" ; then
	mute git checkout "${branch_name}"
	git_pull
else
	git_pull
	mute git checkout -b "${branch_name}"
fi
mute git stash pop
mute git add --all .
git status
echo "(Paused before diff)"
echo "Diff commands:"
echo "q - exit diff with 0, continuing this script"
echo "g - scroll to top"
echo "G - scroll to bottom"
read -p '(continue)'
git diff --staged
read -p '(continue)'
git commit
git push --set-upstream origin "$1"
echo
echo "pushto $1 done"
echo
