#!/bin/bash

set -e

if [ $# -eq 0 ]
then
  echo "Usage: $(basename $0) <substring> | (<root> <args>...)"
  echo "  e.g. $(basename $0) foo"
  echo "  e.g. $(basename $0) . -iname '*foo*'"
  echo "Mode 1: Current directory scan for files and directories matching name with case-insensitive substring"
  echo "Mode 2: Specific directory and classic find operators required"
  echo "Find command that ignores these directories:"
  echo ".svn"
  echo ".git"
  echo ".idea"
  echo "target"
  echo "node_modules"
  exit 1
fi

if [ $# -eq 1 ]
then
  location='.'
  args=('-iname' "*$1*")
else
  location="$1"
  shift
  args=("$@")
fi

find -E "${location}" \
-name .git -type d -prune -o \
-name .svn -type d -prune -o \
-name .idea -type d -prune -o \
-name target -type d -prune -o \
-name node_modules -type d -prune -o \
"${args[@]}" -print

