#!/bin/bash

. ~/.bashrc_local_variables

asap_git() {
  "${code}"/elspleth/helper-scripts/git/qgit.sh "$@"
}

realtime_git() {
  "${code}"/elspleth/helper-scripts/git/generic_all_git.sh "$@"
}

# The idea behind the Morning script is to sip a hot beverage and watch

cd "${code}"
echo 
echo "                             Fetching and pruning"
echo
time asap_git fetch --prune

