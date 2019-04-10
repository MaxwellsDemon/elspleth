#!/bin/bash

# Launches Studio in a loop until the presence of a sibling "stop" named file
# Optional first arg: name of file to edit

# --- Variables ---

studio_bin='/c/Program Files (x86)/CORENA Studio/Studio-7.5.0/bin/'
executable="${studio_bin}/studio.exe"

stop_file="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"/stop

usage() {
  echo
  echo "Usage: $0 <file>"
  echo
  echo "Opens a file in Studio, reopening when closed until ctrl+C or this file exists: ${stop_file}"
}
usage

if [ $# -ne 1 ]
then
  exit 1
fi
file_to_edit=${1}



# --- Loop launch Studio --

cd "${studio_bin}"
while [ ! -e "${stop_file}" ]
do
  "${executable}" "${file_to_edit}"
done

rm "${stop_file}"

echo
echo "Stopping loop."
echo "Removing file ${stop_file}"

