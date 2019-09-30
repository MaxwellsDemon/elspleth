#!/bin/bash
set -e

sed_inplace() {
  if sed --version > /dev/null 2>&1 ; then
    # GNU sed
    sed -i "$@"
  else
    # BSD (mac) sed
    sed -i '' "$@"
  fi
}

