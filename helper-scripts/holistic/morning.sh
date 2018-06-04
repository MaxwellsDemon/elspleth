#!/bin/bash

. ~/.bashrc_local_variables

agit() {
	"${code}"/elspleth/helper-scripts/git/generic_all_git.sh "$@"
}

# The idea behind the Morning script is to sip a hot beverage and watch
# repositories update one-by-one and grok changes.  That's why sequential 
# agit is used instead of fast async qgit.
agit fetch --prune

