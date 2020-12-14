#!/bin/bash
set -x

date "+%Y-%m-%d-%H-%M-%S"

echo "universal, with milliseconds, and simpler punctuation, nanoseconds did not work on charter Gitlab runner"
date --utc +"%Y-%m-%d_%H-%M-%S-%3N"

echo "so this is safer but only second resolution
date --utc +"%Y-%m-%d_%H-%M-%S"

