#!/bin/bash
scripts_dir=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd)
QUICK=TRUE bash "${scripts_dir}/generic_all_git.sh" "$@"
