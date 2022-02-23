#!/bin/bash 

#get the current date
BACKUPTIME=`date +%F-%T` 

#create a backup file using the current date in it's name
DESTINATION=/home/ubuntu/backup/log-$BACKUPTIME.tar.gz 

#the folder that contains the files that we want to backup
SF0=/home/ubuntu/files
SF1=/home/ubuntu/files1
SF2=/home/ubuntu/files2
SF3=/home/ubuntu/files3
SF4=/home/ubuntu/files4
SF5=/home/ubuntu/files5

#create the backup
tar -cpzf $DESTINATION $SF0 $SF1 $SF2 $SF3 $SF4 $SF5

#Go to the backup folder location
cd $DESTINATION

#Show the size of the folder
du -sh

echo "Backup finished"


