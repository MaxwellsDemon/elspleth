#!/bin/bash
scripts_dir=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd)
TRAVERSAL=deep bash "${scripts_dir}/multi_mvn.sh" "$@"

