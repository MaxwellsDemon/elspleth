#!/usr/local/bin/bash

bash_major_version="$(printf %.1s "$BASH_VERSION")"
if [[ $bash_major_version -lt 5 ]]; then
  echo "The shell is not BASH version 5 or greater. Review the shebang declaraction at the top of the script for the expected bash location. Exiting."
  exit 1
fi

