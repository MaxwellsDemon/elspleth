#!/bin/bash

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



