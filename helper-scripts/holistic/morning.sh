#!/bin/bash

set -e
. ~/.bashrc_local_variables

run_git() {
  "${code}"/elspleth/helper-scripts/git/staggered-git.sh "$@"
}

# The idea behind the Morning script is to sip a hot beverage and watch
fetch() {
  cd "$1"
  echo 
  echo "                             Fetching and pruning $1"
  echo
  time run_git fetch --prune
}

# Local to Kenzan laptop
fetch "/code-temporary-gitlab-urls"

# Globally works
fetch "${code}"

