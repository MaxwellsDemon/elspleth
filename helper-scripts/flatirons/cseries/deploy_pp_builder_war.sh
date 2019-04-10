#!/bin/bash

# Hi!
# This script will build your local data-manager-builder-base for CSeries and push a war file to DEV builder.
# To adopt this script, review the first 3 variables below.

set -e

# === CHANGE AS NEEDED =========================================

# 1) Your Builder display name
builder_name="Curtis"

# 2) Your foreign Builder directory
builder_dir_name="CURTIS_BUILDER"

# 3) Your local code home
git_projects_dir='/c/code/git-projects'


# C-Series development machine (Flatirons hosted)
dev_target='tsxadmin@10.3.1.18'

# Git projects
builder_base="${git_projects_dir}/data-manager-builder-base"
stylesheets="${git_projects_dir}/stylesheets"
tir_cir_converter="${git_projects_dir}/tir-cir-converter"

projects=("${stylesheets}" "${tir_cir_converter}" "${builder_base}")

# Foreign path, Builder being updated with new .war
builder_dir="/home/apps/corena/${builder_dir_name}"


# ==============================================================

# Builder tomcat
tomcat="${builder_dir}"/tomcat

# Search-and-replace test to rename the builder as a temporary patch
builderInfo_before="\"name\": \"CSeries Builder"
builderInfo_after="\"name\": \"${builder_name} CSeries Builder"
builderInfo_path="${builder_base}/builder-package-cseries/src/main/resources/builderInfo.json"

target='no_target'
war_name_long='builder-package-cseries-99.99-SNAPSHOT.war'
war_name_short='buildcseries'
dest_war_path="${tomcat}/webapps/${war_name_short}.war"

# ==============================================================

usage() {
  echo "usage: $0 <env>"
  echo
  echo "      dev       ${dev_target}"
  exit 1
}

if [ $# -ne 1 ]
then
  usage
fi

if [ "$1" != dev ]
then
  echo "Unsupported environment $1"
  usage
fi

# Interpret command line
if [ "$1" = dev ]
then
  target="${dev_target}"
fi

# ----- Build War -------------------------------------------------------------------------------------------------------------

verify_project_exists() {
  if [ ! -d "$1" ]
  then
    echo
    echo "Could not find project: $1"
    echo
    echo "Update this script's git_projects_dir variable"
    echo
    echo "Ensure these projects exist:"
    for project in "${projects[@]}"
    do
      echo "  ${project}"
    done
    exit 2
  fi
}

mvn_build() {
  pushd . > /dev/null
  cd "${1}"
  project_name=$(basename "${1}")
  echo
  echo -e "\e[93m${project_name}\e[0m"
  echo
  mvn clean install -Dmaven.test.skip=true
  popd > /dev/null
}


for project in "${projects[@]}"
do
  verify_project_exists "${project}"
done

# Temporarily doctor builder file name
sed -i "s/${builderInfo_before}/${builderInfo_after}/g" "${builderInfo_path}"

for project in "${projects[@]}"
do
  mvn_build "${project}"
done

# Revert doctored builder file name
sed -i "s/${builderInfo_after}/${builderInfo_before}/g" "${builderInfo_path}"

# ----- Upload War ------------------------------------------------------------------------------------------------------------

echo -e "\nUploading war file to $1"
scp "${builder_base}"/builder-package-cseries/target/"${war_name_long}" "${target}":"${builder_dir}"

# ----- Deploy War ------------------------------------------------------------------------------------------------------------

echo -e "\nDeploying war file on $1"

# Special "Here document" notation which acts like [interactive-program << command-file]
# http://www.tldp.org/LDP/abs/html/here-docs.html
# Note that stderr for ssh itself is eaten but stderr for remote commands are redirected to stdout
ssh "${target}" 2> /dev/null << EOF
{
  cd "${builder_dir}"

  echo "Stopping Tomcat"
  "${tomcat}/bin/shutdown.sh"
  
  echo "Cleaning Tomcat (work, wars, logs)"
  rm -rf "${tomcat}/work/Catalina"
  rm -rf "${tomcat}/webapps/${war_name_short}"
  rm -rf "${dest_war_path}"
  rm -rf "${tomcat}/logs"
  mkdir "${tomcat}/logs"
  touch "${tomcat}/logs/catalina.out"

  echo "Moving war file"
  mv "${builder_dir}/${war_name_long}" "${dest_war_path}"

  echo "Starting Tomcat"
  "${tomcat}/bin/startup.sh"

  echo -e "\nTailing catalina.out (ctrl+c to get out)\n"
  sleep 2
  tail -f "${tomcat}/logs/catalina.out"
} 2>&1
EOF

# Note: The previous "tail" command eats the terminal and forces the user to ctrl+C, ending this script

