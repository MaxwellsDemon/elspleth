#!/bin/bash

if [ $# -eq 0 ]
then
	echo "Usage: findreal <root dir> <find expression>"
	echo "Find command that ignores these directories:"
	echo ".svn"
	echo ".git"
	echo "target"
	exit 1
fi

location="$1"
shift

# The quoted "$@" is essential to keep intact original quoting
# (to not process spaces and asterisks)
# eg.
#		findreal . a '*b c*' d 
#	has 4 arguments
# And "$@" causes the find command to see the desirable 4 args instead of 5,
#	or worse, a million args because of undesirable asterisk expansion

find "${location}" \
-name .git -type d -prune -o \
-name .svn -type d -prune -o \
-name target -type d -prune -o \
"$@" -print
