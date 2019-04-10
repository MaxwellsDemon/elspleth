#!/bin/bash
set -e

reset_totals() {
  total_branches=$(git branch -r | wc -l)
  merged_branch_is_evergreen=0
  merged_branch_two_weeks_young=0
  merged_branch_deleteable=0
}

print_totals() {
  echo
  echo "Total branches: ${total_branches}"
  echo "Not deleting merged branches that are two weeks young: ${merged_branch_two_weeks_young}"
  echo "This leaves ${merged_branch_deleteable} branch(es) for removal"
}

for_each_deleteable_branch() {
  for rawBranch in $(git branch -r --merged develop); do
    local norm_branch=$(normalize_branch_name "${rawBranch}")
    local branch=$(strip_origin "${norm_branch}")
    if is_branch_name_malformed "${branch}"; then
      echo "Skipping malformed branch entry: ${rawBranch}"
    elif is_branch_evergreen "${branch}"; then
      ((merged_branch_is_evergreen++))
      echo "Skipping evergreen branch: ${branch}"
    elif is_branch_younger_than_two_weeks "${norm_branch}"; then
      ((merged_branch_two_weeks_young++))
      echo "Skipping younger than 2 week branch: ${branch}"
    else
      ((merged_branch_deleteable++))
      "$@" "${branch}"
    fi
  done
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

unit_test() {
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
  assert_true is_branch_younger_than_two_weeks develop
  echo "Unit tests pass"
  set -e
}

action() {
  echo "DELETEABLE BRANCH: $1"
  # git checkout "$1"
  # git push origin :"$1"
}

unit_test
reset_totals
for_each_deleteable_branch action
print_totals

