#!/bin/bash

count() {
  echo "count: $#, args: $@"
  echo "arg 2: $2"
  echo
}

count "$@"
foo=("$@")
count "${foo[@]}"

# ./at-to-arrays.sh 'a a' 'b b' 'c c'
# count: 3, args: a a b b c c
# arg 2: b b
# 
# count: 3, args: a a b b c c
# arg 2: b b
