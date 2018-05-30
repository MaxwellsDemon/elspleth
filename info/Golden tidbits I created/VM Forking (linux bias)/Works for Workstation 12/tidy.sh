#!/bin/bash

# Assumes all Git projects on the file system are fair game for tidying up
# The Maven project check is nested in the Git project check to avoid modifying Maven projects
#	found in products like Eclipse. Bad things can happen.

find / -name '.git' 2> /dev/null | while read line ; do

	cd `dirname ${line}`
	p=`pwd`
	echo
	echo "Found git project $p"
	echo
	
	git gc

	if [ -r pom.xml ]
	then
		echo
		echo "found Maven project $p"
		echo

		mvn clean
	fi	

done

echo
echo "About to delete ~/.cache"
rm -rf ~/.cache
mkdir ~/.cache

echo
echo "About to delete Tomcat logs"
sudo service tomcat stop
rm -rf /opt/tomcat/logs/*


