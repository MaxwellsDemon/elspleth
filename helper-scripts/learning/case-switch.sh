#!/usr/local/bin/bash
set -eo pipefail

case "$1" in
  list)
  mode=list_action
  ;;
  delete)
  mode=delete_action
  ;;
  *)
  echo "Unknown option: $1"
  # usage
  exit 2
  ;;
esac

echo "Mode is: ${mode}"
