#!/bin/bash
set -e

# TODO node package.json support. Currently limited to maven.

# ===========  Let's gather a happy path  ===============

usage() {
  echo "usage: $(basename $0) <release version> <open version>"
  echo
  echo "Have the current directory be the desired project to release."
  exit 1
}

if [ $# -ne 2 ] ; then
  usage
elif ! hash xmlstarlet 2>/dev/null ; then
  echo >&2 "I require an XML utility to work (a command called 'xmlstarlet' is not on the path).  Aborting."
  exit 1
else
  release_version="$1"
  open_version="$2"
fi

git checkout develop
git pull

if [ -f pom.xml ] ; then
  original_version="$(xmlstarlet sel -N pom=http://maven.apache.org/POM/4.0.0 -t -v '/pom:project/pom:version' pom.xml)"
else
  echo "No pom.xml found. Exiting."
  exit 3
fi

echo
echo "For project  $(basename $(pwd))"
echo "For branch   develop"
echo
echo "Currently    ${original_version}"
echo "releasing    ${release_version}"
echo "Opening      ${open_version}"
echo
echo "Look good?"
read -p '...'

mvn clean verify
git checkout master
git pull
git merge develop
xmlstarlet ed --inplace -P -N pom=http://maven.apache.org/POM/4.0.0 --update '/pom:project/pom:version' -v "${release_version}" pom.xml
git add pom.xml
git commit -m "Release ${release_version}"
git tag "${release_version}"
git push origin master --tags

git checkout develop
git merge master
xmlstarlet ed --inplace -P -N pom=http://maven.apache.org/POM/4.0.0 --update '/pom:project/pom:version' -v "${open_version}" pom.xml
git add pom.xml
git commit -m "Open version ${open_version}"
git push origin develop

echo
echo "now build the master branch in Jenkins!"
echo

# ===========  End happy path  ==========================

