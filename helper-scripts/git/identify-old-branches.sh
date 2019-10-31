#!/bin/bash

set -e

for k in $(git branch -r | sed /\*/d); do
  if [ "${k}" = '->' ] ; then
    continue
  fi
  if [ -z "$(git log -1 --after='24 week ago' -s $k)" ]; then
  echo "${k#origin/}"
  fi
done
