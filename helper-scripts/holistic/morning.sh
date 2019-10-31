#!/bin/bash

set -e
. ~/.bashrc_local_variables

fast_git() {
  "${code}"/elspleth/helper-scripts/git/fast-git.sh "$@"
}

slow_git() {
  "${code}"/elspleth/helper-scripts/git/slow-git.sh "$@"
}

#(
#  cd "${code}/spc-dev-toolbox/hosts"
#  git checkout kenzan-vpn-hosts
#  git pull
#  bash patch-hosts-file.sh kenzan-vpn-hosts
#)

# The idea behind the Morning script is to sip a hot beverage and watch

cd "${code}"
echo 
echo "                             Fetching and pruning"
echo
time fast_git fetch --prune

