#!/bin/bash

# Assumes git repos with only one remote, namely 'origin'

set -e

usage() {
  echo "usage: $(basename "$0") <list | delete> <place for summary file>"
  echo "The summary file should be put in a directory outside of the current git project"
  echo
  echo "Example: $(basename "$0") list ~/Desktop"
  exit 1
}

reset_totals() {
  total_branches_count=$(git branch -r | wc -l)
  merged_branch_is_evergreen_count=0
  merged_branch_two_weeks_young_count=0
  deleteable_merged_branch_count=0
  deleteable_merged_branches=()
}

print_totals() {
  section "Totals"
  date
  echo "Total remote branches: ${total_branches_count}"
  echo "Branches that would be deleted but were merged less than two weeks ago: ${merged_branch_two_weeks_young_count}"
  echo "Branches for removal: ${deleteable_merged_branch_count}"
  echo 
  echo "Summary file is best viewed with colored text like:"
  echo "cat ${summary_file}"
}

validate() {
  section "Validation"
  echo "In directory $(pwd)"
  if [ ! -d .git ]; then
    echo "Not a git project. Please change directory to root git project."
    exit -22
  fi
  if [ -n "$(git status --porcelain)" ]; then
    echo "Please clean git workspace"
    exit -33
  fi
}

checkout_develop_or_master() {
  section "Checkout of develop or master"
  git fetch
  if mute git checkout develop ; then
    echo "The develop branch exists, use it as the base."
  else
    echo "The develop branch does not exist, using master as the base."
    mute git checkout master
  fi
  git pull
  core_branch="$(git rev-parse --abbrev-ref HEAD)"
}

gather_deleteable_branches() {
  section "Gathering branches"
  echo "Only processing branches already merged into ${core_branch}"
  local merged_branches="$(git branch -r --merged "${core_branch}")"
  while read raw_branch
  do
    local norm_branch=$(normalize_branch_name "${raw_branch}")
    local branch=$(strip_origin "${norm_branch}")
    if is_branch_name_malformed "${branch}"; then
      continue
    else
      echo
      echo "Branch ${raw_branch}"
    fi
    if is_branch_evergreen "${branch}"; then
      ((merged_branch_is_evergreen_count++))
      echo "Evergreen. Skipping."
    elif is_branch_younger_than_two_weeks "${norm_branch}"; then
      ((merged_branch_two_weeks_young_count++))
      echo "Merged less than two weeks ago. Skipping."
    else
      echo "Deleteable"
      ((deleteable_merged_branch_count++))
      deleteable_merged_branches+=("${branch}")
    fi
  done <<< "${merged_branches}"
}

for_each_deleteable_branch() {
  section "List / Delete"
  echo "========================================================================"
  for branch in "${deleteable_merged_branches[@]}" ; do
    "$@" "${branch}"
  done
  echo "========================================================================"
}

normalize_branch_name() {
  echo "$1" | sed -E 's,^ *,,g'
}

strip_origin() {
  echo "$1" | sed -E 's,^origin/,,g'
}

is_branch_younger_than_two_weeks() {
  local branch_unix_time=$(git show -s --format="%ct" "$1")
  local now_unix_time=$(date +%s)
  local diff=$(($now_unix_time - $branch_unix_time))
  local two_weeks_in_seconds=$((60 * 60 * 24 * 14))
  # echo "branch unix time:     ${branch_unix_time}"
  # echo "now unix time:        ${now_unix_time}"
  # echo "diff in seconds:      ${diff}"
  # echo "two weeks in seconds: ${two_weeks_in_seconds}"
  [ $diff -lt $two_weeks_in_seconds ]
}

is_branch_name_malformed() {
  echo "$1" | grep --silent -P '\s|->'
}

is_branch_evergreen() {
  [ "$1" = master -o "$1" = develop ] || echo "$1" | grep --silent '^release/'
}

assert_true() {
  "$@"
  if [ $? -ne 0 ] ; then
    echo "Failed to assert true: $@"
    exit -1
  fi
}

assert_false() {
  "$@"
  if [ $? -eq 0 ] ; then
    echo "Failed to assert false: $@"
    exit -1
  fi
}

assert_equals() {
  if [ "$1" != "$2" ]; then
    echo "Failed test: '$1' = '$2'"
    exit -1
  fi
}

mute() {
  "$@" > /dev/null 2>&1
}

section() {
  echo
  echo -e "\x1B[93m$1\x1B[0m"
  echo
}

unit_test() {
  section "Unit Tests"
  set +e
  assert_true is_branch_evergreen master
  assert_true is_branch_evergreen develop
  assert_true is_branch_evergreen 'release/TEST-123'
  assert_true is_branch_name_malformed 'origin/HEAD -> origin/develop'
  assert_true is_branch_name_malformed 'HEAD -> develop'
  assert_false is_branch_evergreen 'my_feature'
  assert_false is_branch_name_malformed 'my_feature'
  assert_equals 'origin/my_feature' $(normalize_branch_name '   origin/my_feature')
  assert_equals 'my_feature' $(strip_origin 'origin/my_feature')
  # quasi-stable check that develop branch is actively updated
  (assert_true is_branch_younger_than_two_weeks develop)
  echo "Unit tests pass"
  set -e
}

list_action() {
  echo "Deleteable branch: $1"
}

delete_action() {
  echo "Deleting branch: $1"
  mute git checkout "$1"
  mute git checkout "${core_branch}"
  # Extra safe deletion check with '-d' instead of '-D' before remote delete
  git branch -d "$1"
  git push origin :"$1"
}

main_logic() {
  unit_test
  validate
  checkout_develop_or_master
  reset_totals
  gather_deleteable_branches
  for_each_deleteable_branch "${mode}"
  print_totals
}

# --------------------------

if [ $# -ne 2 ] ; then
  usage
fi

case "$1" in
  list)
  mode=list_action
  ;;
  delete)
  mode=delete_action
  ;;
  *)
  "Unknown option: $1"
  usage
  exit 2
  ;;
esac

summary_file="$2/branch-cleanup-summary.txt"
main_logic | tee --append "${summary_file}"

