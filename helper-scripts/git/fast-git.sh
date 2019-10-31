#!/bin/bash
scripts_dir=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd)
QUICK=TRUE bash "${scripts_dir}/slow-git.sh" "$@"

