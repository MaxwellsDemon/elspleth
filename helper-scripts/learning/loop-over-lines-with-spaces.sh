#!/bin/bash

# GOOD VERSION: variable modifications inside loop are visible outside loop

myContent="$(find . -type f -name "*helloworld*" -print)"
while read entry
do
  echo "Found: $entry"
done <<< "${myContent}"

# PROBLEMATIC VERSION: while-loop runs in subshell, so variable modifications are not visible outside loop

find . -type f -name "*helloworld*" -print | while read entry
do
  echo "Found: $entry"
done

