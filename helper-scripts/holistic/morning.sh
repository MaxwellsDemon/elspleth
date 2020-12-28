#!/bin/bash

set -e
. ~/.bashrc_local_variables

# The idea behind the Morning script is to sip a hot beverage and watch
refresh_repos() {
  cd "$1"
  echo 
  echo "                             Fetching and pruning $1"
  echo
  time run_git fetch --prune --all --tags
}

run_git() {
  "${code}"/elspleth/helper-scripts/git/staggered-git.sh "$@"
}

refresh_repos "${gcode}"
refresh_repos "${code}"

