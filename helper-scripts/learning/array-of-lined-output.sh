#!/usr/local/bin/bash
set -eo pipefail

print_data_with_spaces() {
  echo hello world
  echo foo bar
}

print_parameters() {
  for param in "$@"; do
    echo "Parameter: ${param}"
  done
}

mapfile -t my_array < <(print_data_with_spaces)
print_parameters "${my_array[@]}"

echo; echo; echo; echo
cat array-of-lined-output.sh
