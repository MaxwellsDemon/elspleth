#!/bin/bash

echo
echo 'Prepares and shrinks all file system partitions (using Google and Stackoverflow magic)'
echo
echo 'EXPECT this message'
echo '    "cat: write error: No space left on device"'
echo

echo "Only press enter if all VM snapshots are delete. Otherwise ctrl+C"
read

# Loop over partitions
df --output='target' | while read line ; do

	# This skips the "Mounted on" label
	if [ -d "$line" ]
	then
		cd "$line"
		echo `pwd` is about to be zeroed-out
		# Overwrite available space with zeros
		cat /dev/zero > zero.fill;sync;sleep 1;sync;rm -f zero.fill
	fi
done

echo
echo 'About to run VMware shrink utility.'
echo
vmware-toolbox-cmd disk shrinkonly

echo
echo 'Shrink script done.'
