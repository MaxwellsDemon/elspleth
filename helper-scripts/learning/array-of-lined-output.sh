#!/usr/local/bin/bash
set -eo pipefail

print_data_with_spaces() {
  echo hello world
  echo foo bar
}

print_parameters() {
  local param # ESSENTIAL to not break outer-loop variables
  for param in "$@"; do
    echo "Parameter: ${param}"
  done
}

mapfile -t my_array < <(print_data_with_spaces)
param=globalvalue
print_parameters "${my_array[@]}"
echo "The global variable [param] has value [${param}]"

echo; echo; echo; echo
cat array-of-lined-output.sh
