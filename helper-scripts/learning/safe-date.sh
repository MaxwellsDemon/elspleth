#!/bin/bash

set -x
date "+%Y-%m-%d-%H-%M-%S"
set +x

echo
echo "universal, with milliseconds, and simpler punctuation, nanoseconds did not work on charter Gitlab runner"
set -x
date --utc +"%Y-%m-%d_%H-%M-%S-%3N"
set +x

echo
echo "so this is safer but only second resolution"
set -x
date --utc +"%Y-%m-%d_%H-%M-%S"
set +x

