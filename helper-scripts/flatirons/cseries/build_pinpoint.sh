#!/bin/bash

time (

# Stop build on any failure
set -e

tests=$1

usage() {
  echo "usage: $0 <--test | --notest | --verify>"
  exit 1
}


# Notes:
# - clean target is required for at least data-manager (datamanager-integrationtests)

# For at least data-manager/server/integration-tests/runnable-tests,
# It fails for 
#   -Dmaven.test.skip=true
# but is successful for 
#   -DskipTests

args=''
if [ $# -ne 1 ]; then
  usage
elif [ $tests = '--test' ]; then
  args='clean install'
elif [ $tests = '--notest' ]; then
  args='clean install -DskipTests'
elif [ $tests = '--verify' ]; then
  args='verify'
else
  usage
fi

mvn_build() {
  pushd . > /dev/null
  cd "${1}"
  echo
  echo -e "\e[93m${1}\e[0m"
  echo
  echo "mvn $args"

  mvn $args
  echo
  echo "Ran: mvn $args"
  echo

  popd > /dev/null
}

# I think stylesheets has to be before data-manager-builder-base for tests to pickup changes

# No evidence of dependency between stylesheets and tir-cir-converter in pom (yet) but
# tir-cir-converter definitely uses stylesheets for conversion.


# ====== Start of builds ==========
mvn_build commons
# mvn_build access-control-manager
mvn_build stylesheets
mvn_build tir-cir-converter
mvn_build data-manager-builder-base
# mvn_build data-manager

echo -e "\nDone building everything."

)
# End time tracking

