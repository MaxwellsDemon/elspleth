#!/bin/bash
set -eo pipefail

usage() {
  echo "usage: $(basename "$0") <root dir> <command> [<command arg> ...]"
  echo 'Bash can export functions with `export -f the_fuction` and then use it as the foreach command'
  exit 1
}
if [ $# -lt 2 ]; then
  usage
fi

root_dir="$1"
shift

project_paths=()
for git_dir in $(find "${root_dir}" -maxdepth 2 -type d -name .git | sort)
do
  project_paths+=($(realpath "${git_dir}/.."))
done

for project_path in "${project_paths[@]}"; do
(
  cd "${project_path}"
  "$@"
)
done

