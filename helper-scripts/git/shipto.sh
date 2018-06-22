#!/bin/bash

set -e

function usage() {
	echo "usage: $(basename $0) <destination branch name>"
	echo "  Does: stash, develop pull, checkout/create branch, stash pop, add all, status/diff, commit, push"
	exit 1
}

# Run arbitrary command quietly
function mute() {
	"$@" 2> /dev/null 1>&2
}

if [ $# -ne 1 ]; then
	usage
fi

if [ ! -d .git ]; then
	echo "Change to root Git project directory"
	exit 2
fi

mute git add --all .
mute git stash

if git branch | grep develop > /dev/null
then
	mute git checkout develop
fi
mute git pull
if git branch | grep "$1" > /dev/null
then
	mute git checkout "$1"
else
	# git checkout returns 0 if already on branch
	# git checkout returns 128 if branch already exists
	mute git checkout -b "$1"
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
git commit
git push --set-upstream origin "$1"
echo
echo "Small commit done"
echo
