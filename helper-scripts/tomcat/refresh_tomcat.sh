#!/bin/bash

work_to_del=work/Catalina/localhost
script_dir=$(cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd)

usage() {
  echo
  echo "Usage: $0 [--eraselogs] [--builders | <tomcat directory>]"
  echo
  echo "  --eraselogs (-e)  Erases logs/*"
  echo
  echo "  --builders        Processes all tomcats directories matching this path and owned by the current user. Does not tail catalina.out"
  echo "                    /home/apps/corena/*_BUILDER/tomcat"  
  echo
  echo "Does these steps:"
  echo "  Stops Tomcat"
  echo '  Deletes logs/* (if --eraselogs)'
  echo "  Deletes ${work_to_del}"
  echo "  Starts Tomcat"
  echo "  Tails catalina.out"
  echo
  exit 1
}

if [ $# -eq 0 ]
then
  usage
fi

while [[ $# -gt 0 ]]
do
  key="$1"
  case $key in
    --builders)
    builders=YES
    shift
    ;;
    -e|--eraselogs)
    eraselogs=YES
    shift
    ;;
    -*)
    echo -e "\nUnknown option $1\n"
    usage
    shift
    ;;
    *)
    tomcat_home="$1"
    shift
    ;;
  esac
done

refresh_tomcat() {
  tomcat="$1"
  # Only process Tomcat directories OWNED BY THE CURRENT USER
  if [ -O "${tomcat}" ]; then
    builder_name=$(basename $(realpath "${tomcat}/.."))
  
     echo -e "\n\e[93m${builder_name}\e[0m\n"
    echo "Tomcat: ${tomcat}"
  
    echo
    echo "Shutting down Tomcat"
    "${tomcat}/bin/shutdown.sh"
    # Run special pause script
    pause_script="${script_dir}/wait_tomcat_end.sh"
    if [ -f "${pause_script}" ]
    then
      "${pause_script}" "${tomcat}"
    fi
  
    if [ "$eraselogs" = YES ]
    then
      echo "Deleting Tomcat logs/*"
      echo
      rm -rf "${tomcat}"/logs/*
    fi
    echo "Deleting Tomcat ${work_to_del}"
    rm -rf "${tomcat}/${work_to_del}"
    echo
    echo "Starting Tomcat"
    "${tomcat}/bin/startup.sh"
  fi
}

if [ "$builders" = YES ]
then
  for tomcat in /home/apps/corena/*_BUILDER/tomcat
  do
    refresh_tomcat "${tomcat}"
    seconds=20
    echo "Sleeping for ${seconds} seconds while builder starts up"
    sleep $seconds
  done
  echo
  echo -e "\e[93mNOTE! \e[0m Only tomcat directories owned by the current user were processed"
  echo
else
  # Poor man's realpath for portability
  tomcat_home=$(cd -L "${tomcat_home}"; pwd)
  if [ ! -d "${tomcat_home}/bin" ]
  then
    echo
    echo "Is this a tomcat directory? ${tomcat_home}"
    echo "It is missing a bin/ directory"
    echo
    exit 3
  fi
  if [ ! -d "${tomcat_home}/webapps" ]
  then
    echo
    echo "Is this a tomcat directory? ${tomcat_home}"
    echo "It is missing a webapps/ directory"
    echo
    exit 3
  fi
  refresh_tomcat "${tomcat_home}"
  echo
  echo "Tailing catalina.out (ctrl+C to escape)"
  echo
  sleep 2
  tail -f "${tomcat_home}/logs/catalina.out"
fi

