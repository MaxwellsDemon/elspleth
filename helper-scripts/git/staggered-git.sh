#!/bin/bash
scripts_dir=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd)
QUICK=STAGGERED bash "${scripts_dir}/slow-git.sh" "$@"

