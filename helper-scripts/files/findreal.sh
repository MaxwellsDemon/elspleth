#!/bin/bash

if [ $# -eq 0 ]
then
	echo "Usage: findreal <root dir> <find expression>"
	echo "  e.g. findreal . -iname foo"
	echo "Find command that ignores these directories:"
	echo ".svn"
	echo ".git"
	echo ".idea"
	echo "target"
	echo "node_modules"
	exit 1
fi

location="$1"
shift

# The quoted "$@" is essential to keep intact original quoting
# (to not process spaces and asterisks)

find "${location}" \
-name .git -type d -prune -o \
-name .svn -type d -prune -o \
-name .idea -type d -prune -o \
-name target -type d -prune -o \
-name node_modules -type d -prune -o \
"$@" -print

