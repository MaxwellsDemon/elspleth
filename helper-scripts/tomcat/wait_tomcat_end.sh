#!/bin/bash

# $1 is the tomcat home directory

# Max wait in seconds
timeout=15
# Check period in seconds
interval=1
# Delay between SIGTERM and SIGKILL
delay=2


usage() {
	echo
	echo "Usage: $0 <tomcat home>"
	echo
	echo "Waits until every matching tomcat process ends, killing the process after ${timeout} seconds"
	echo
	exit 1
}

if [ $# -ne 1 ]
then
	usage
fi

tomcat_home="$1"
if [ ! -d "${tomcat_home}" ]
then
	tomcat_home=$(cd "${tomcat_home}" && pwd)
	if [ ! -d "${tomcat_home}" ]
	then
		echo "Not a Tomcat home: $1"
		usage
	fi
fi

if [ ! -d "${tomcat_home}/bin" ]
then
    echo
    echo "Is this a tomcat directory? ${tomcat_home}"
    echo "It is missing a bin/ directory"
    echo
    usage
fi
if [ ! -d "${tomcat_home}/webapps" ]
then
    echo
    echo "Is this a tomcat directory? ${tomcat_home}"
    echo "It is missing a webapps/ directory"
    echo
    usage
fi


next_tomcat() {
	# At least two grep commands is needed to clear out the ps command itself
	ps_line=$(ps aux | grep "catalina.home=${tomcat_home}" | grep org.apache.catalina.startup.Bootstrap | sed -n 1p)
	tomcat_pid=$(echo "${ps_line}" | awk '{print $2}')
}

next_tomcat

if [ -z "$tomcat_pid" ]
then
	echo "Tomcat is shut down."
	exit 0
fi

while [ -n "$tomcat_pid" ]
do
	echo
	echo "Waiting for Tomcat PID $tomcat_pid to naturally end for up to $timeout seconds"
	echo
	# echo "Details:"
	# echo "${ps_line}"
	# echo
	{
	    ((t = timeout))
	
	    while ((t > 0)); do
			echo "${t}..."
	        sleep $interval
			if ps -p $tomcat_pid > /dev/null
			then
	        	((t -= interval))
			else
				echo "Tomcat is shut down."
				break
			fi
	    done

		if ps -p $tomcat_pid > /dev/null
		then
			echo "Ending Tomcat process $tomcat_pid"
	    	# Be nice, post SIGTERM first.
	    	# The 'exit 0' below will be executed if any preceeding command fails.
	    	kill -s SIGTERM $tomcat_pid
	    	sleep $delay
	    	kill -s SIGKILL $tomcat_pid
		fi
	} 2> /dev/null

	next_tomcat
done

