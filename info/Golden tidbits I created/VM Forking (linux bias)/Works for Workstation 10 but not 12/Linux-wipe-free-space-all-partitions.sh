#!/bin/bash

echo
echo 'Run this script to prepare a Linux VM for VMware compacting.'
echo 'This script assumes the VM has no snapshots.'
echo
echo 'Each file system partition will have its empty space overwritten with zero-bits.'
echo 'The following message is expected:'
echo '    cat: write error: No space left on device'
echo 

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

