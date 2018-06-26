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
echo 
echo 
echo 
echo "                             Fetching and pruning"
echo "                             (If Charter repos hang, keep killing and retrying)"
echo
realtime_git fetch --prune
