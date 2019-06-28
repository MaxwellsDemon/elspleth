#!/bin/bash
set -e

# inputs: major/minor/patch release

# package.json and/or pom.xml

# get pom.xml version
# get package.json version

# source branch must be release/* or develop

# TODO
# logic to bump major/minor/patch version and update version string in pom or package.json


# ===========  Let's gather a happy path  ===============

usage() {
  echo "usage: $(basename $0) <release version> <open version>"
  echo
  echo "Have the current directory be the desired project to release."
  exit 1
}

if [ $# -ne 2 ] ; then
  usage
fi

# release_version='0.9.0'
# open_version='0.10.0-SNAPSHOT'
release_version="$1"
open_version="$2"

echo "For project  $(basename $(pwd))"
echo
echo "releasing    ${release_version}"
echo "Opening      ${open_version}"
echo
echo "Look good?"
read -p '...'

git checkout develop
git pull
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

