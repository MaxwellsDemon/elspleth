#!/bin/bash

set -e

if [ -d "$1" ]
then
  echo "Deep scan for Git and Maven projects in $1"
else
  echo "Specify root directory to scan for Git and Maven projects"
  exit 1
fi

# Assumes all Git projects on the file system are fair game for tidying up
# The Maven project check is nested in the Git project check to avoid modifying Maven projects
#  found in products like Eclipse. Bad things can happen.

find "$1" -name '.git' 2> /dev/null | while read line ; do
  pushd .
  cd `dirname ${line}`
  p=`pwd`
  echo
  echo "Found git project $p"
  echo
  git gc
  popd
done

find "$1" -name target -prune -o -name 'pom.xml' -print 2> /dev/null | while read line ; do
  pushd .
  cd `dirname ${line}`
  p=`pwd`
  echo
  echo "found Maven project $p"
  echo
  rm -rf target
  popd
done

echo
echo "Tidy done"
echo

