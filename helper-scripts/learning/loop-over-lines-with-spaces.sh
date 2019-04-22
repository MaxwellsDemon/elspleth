#!/bin/bash

find . -type f -name "*helloworld*" -print | while read entry
do
  echo "Found: $entry"
done

