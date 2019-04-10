#!/bin/bash

usage() {
  echo
  echo "usage: unnest_zips <source dir> <output dir>"
  echo
  echo "Recursively copies directories and files to the output directory."
  echo
  echo "Decompression with 'unzip' is attempted on every file and if successful"
  echo "a directory of the output content is used instead of copying the file."
  echo
  echo "The decompressed content is applied through the same algorithm, "
  echo "decompressing nested files."
  exit 1
}

if [ $# -ne 2 ]
then
  usage
fi

source="$1"
target="$2"
sands_of_time="${target}/recursive_zip_temp"
grain="${sands_of_time}/grain"

if [ -e "${target}" ]
then
  echo "Output directory already exists: ${target}"
  exit 1
fi

if [ ! -e "${source}" ]
then
  echo "Source directory does not exist: ${source}"
  exit 1
fi

mkdir --parents "${sands_of_time}"
cp -r "${source}" "${target}"

queued_expansions=()
current_expansions=("${target}")

while [ ${#current_expansions[@]} -gt 0 ]
do
  for root in "${current_expansions[@]}"
  do
    for file in $(find "${root}" -type f)
    do
      abs_file="${file}"
      echo "Processing: ${abs_file}"
      rm -rf "${grain}"
      mkdir "${grain}"
      unzip -o "${abs_file}" -d "${grain}" 1>> unnest_zip.log 2>&1
      if [ $? -eq 0 ]
      then
        echo
        echo "FOUND A ZIP"
        echo "${abs_file}"
        echo
        # Wow, it's a zip!
        # What would have been a zip file is now a directory by the same name
        rm "${abs_file}"
        mv "${grain}" "${abs_file}"
        queued_expansions+=("${abs_file}")
      fi
    done
  done
  # Paranoid logic
  current_expansions=("${queued_expansions[@]}")
  unset queued_expansions
  queued_expansions=()
done

rm -rf "${sands_of_time}"

