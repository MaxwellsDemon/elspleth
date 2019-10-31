#!/bin/bash

current_branch() {
  git rev-parse --abbrev-ref HEAD
}

validate_current_directory_is_clean_git_root() {
  if [ ! -d .git ]; then
    echo "Not a git project. Please go to project's git root diectory."
    exit -22
  fi
  if [ -n "$(git status --porcelain)" ]; then
    echo "Please clean Git workspace"
    exit -33
  fi
}

checkout_develop_or_master() {
  if ! mute git checkout develop ; then
    mute git checkout master
  fi
}

mute() {
  "$@" > /dev/null 2>&1
}

