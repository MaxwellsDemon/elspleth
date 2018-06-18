#!/bin/bash

set -e

function usage() {
	echo "usage: small_commit <new, full, branch name>"
	exit 1
}

if [ $# -ne 1 ]; then
	usage
fi

echo "=== git diff ==="
git diff
echo
echo "Press enter to continue or exit the command"
echo
read

echo "=== git diff --staged ==="
git diff --staged
echo
echo "Press enter to continue or exit the command"
echo
read

if git branch | grep develop > /dev/null
then
	git checkout develop
fi
git pull
if git branch | grep "$1" > /dev/null
then
	git checkout "$1"
else
	# git checkout returns 0 if already on branch
	# git checkout returns 128 if branch already exists
	git checkout -b "$1"
fi
git add .
git commit
# TODO add the extra stuff for a proper branch track
git push
echo
echo "Small commit done"
echo
