#!/bin/bash

set -e
. ~/.bashrc_local_variables

asap_git() {
  "${code}"/elspleth/helper-scripts/git/qgit.sh "$@"
}

realtime_git() {
  "${code}"/elspleth/helper-scripts/git/generic_all_git.sh "$@"
}

(
  cd "${code}/spc-dev-toolbox/hosts"
  git checkout kenzan-vpn-hosts
  git pull
  bash patch_hosts_file.sh kenzan-vpn-hosts
)

# The idea behind the Morning script is to sip a hot beverage and watch

cd "${code}"
echo 
echo "                             Fetching and pruning"
echo
time asap_git fetch --prune

