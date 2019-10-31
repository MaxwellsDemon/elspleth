#!/bin/bash
set -e
shopt -s extglob dotglob
echo complex-directory/@(.[!.]*|*)

