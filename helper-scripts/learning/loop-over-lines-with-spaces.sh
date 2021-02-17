#!/bin/bash

# GOOD VERSION: variable modifications inside loop are visible outside loop

myContent="$(find . -type f -name "*helloworld*" -print)"
while read entry
do
  if [ -n "${entry}" ]; then
    echo "Found: $entry"
  fi
done <<< "${myContent}"

