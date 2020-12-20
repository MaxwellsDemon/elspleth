#!/usr/local/bin/bash
set -eo pipefail

red() {
  echo -ne "\x1B[31m$1\x1B[0m"
}

green() {
  echo -ne "\x1B[32m$1\x1B[0m"
}

blue() {
  echo -ne "\x1B[94m$1\x1B[0m"
}

light_grey() {
  echo -ne "\x1B[37m$1\x1B[0m"
}

yellow() {
  echo -ne "\x1B[93m$1\x1B[0m"
}

bold() {
  local bold=$(tput bold)
  local normal=$(tput sgr0)
  echo -n "${bold}$1${normal}"
}

# line per arg
header() {
  local data=("$@")
  local data=("${data[@]/#/*      }")
  echo
  echo " *****************************************************"
  echo -en " ${data[@]/%/\\n}"
  echo " *****************************************************"
  echo
}

stump() {
  echo
  echo "+-------------+"
  echo "|-------------| $@"
  echo "+-------------+"
  echo
}

red red
green green
blue blue
light_grey light_grey
yellow yellow
bold bold

header 'This is a header' 'and second line' 'and third'
stump This is a stump

