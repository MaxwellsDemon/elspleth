#!/bin/bash
set -eo pipefail

needs() {
  bad=false
  for app in "$@"; do
    if ! type "$app" &> /dev/null; then
      echo "Needs command [${app}] to be installed."
      bad=true
    fi
  done
  if [ "${bad}" = true ]; then
    echo
    echo "Required commands:"
    printf ' - %s\n' "$@"
    exit 1
  fi
}

# Works on current laptop
needs git column curl tee grep sed

# Intentionally bad
needs totallynotexistingcommand git alsomissing column curl tee grep sed

