#!/bin/bash
echo "changing directory...";
cd <INSERT PROJECT DIRECTORY>;
echo "new location:";
pwd;
vmstatus=$(vagrant status)
is_running=$(echo $vmstatus | grep -w running );
if [[ $is_running == '' ]]; then
	echo "status off or suspended, turning on"
	vagrant up
else
	echo "status on, suspending"
	vagrant suspend
fi 
