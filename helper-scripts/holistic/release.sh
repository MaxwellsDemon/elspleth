#!/bin/bash
# TODO node package.json support. Currently limited to maven.

set -e

usage() {
  echo "usage: $(basename $0) <project path> [<release version> <open version> [<misc mvn build args>...]]"
  echo
  echo "Supports maven projects"
  echo "Will confirm change with you"
  echo
  echo "<project path>      Path to git/maven project. Prints artifact version."
  echo "<release version>   New version for artifact. For master branch. For git tag."
  echo "<open version>      New version for candidate. For develop branch."
  echo "<build args>        Optional arguments to pass maven."
  echo
  exit 1
}

project_path="$1"
release_version="$2"
open_version="$3"

if [ $# -eq 0 ]; then
  usage
fi
if [ ! -d "${project_path}" ]; then
  echo "No project path found at '${project_path}'"
  echo; usage
fi
if [ ! -d "${project_path}/.git" ]; then
  echo "Directory exists but is not a git project: '${project_path}'"
  echo; usage
fi

(
  cd "${project_path}"
  echo "Updating project git..."
  git checkout develop
  git pull
  if [ -f pom.xml ]; then
    original_version="$(mvn org.apache.maven.plugins:maven-help-plugin:3.1.0:evaluate -Dexpression=project.version -q -DforceStdout)"
  else
    echo "No pom.xml found. Exiting."
    exit 3
  fi
  highest_tag="$(git tag --list --sort=-version:refname | head -n1)"

  echo
  echo "project                $(basename $(pwd))"
  echo "branch                 $(git rev-parse --abbrev-ref HEAD)"
  echo "highest tag            ${highest_tag}"
  echo "current artifact       ${original_version}"

  if [ $# -lt 3 ]; then
    exit
  fi
  shift; shift; shift

  echo
  echo "releasing              ${release_version}"
  echo "opening                ${open_version}"
  echo
  echo "Look good?"
  read -p 'Press enter/return to continue or control+c to escape...'

  mvn clean verify $@
  git checkout master
  git pull
  git merge develop
  mvn versions:set -DnewVersion="${release_version}" > /dev/null && mvn versions:commit > /dev/null
  git add pom.xml
  git commit -m "Release ${release_version}"
  git tag "${release_version}"
  git push origin master --tags

  git checkout develop
  git merge master
  mvn versions:set -DnewVersion="${open_version}" > /dev/null && mvn versions:commit > /dev/null
  git add pom.xml
  git commit -m "Open version ${open_version}"
  git push origin develop

  echo
  echo "now go build the master branch in Jenkins!"
  echo
)

