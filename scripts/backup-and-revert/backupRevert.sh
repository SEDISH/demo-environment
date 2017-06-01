#!/bin/bash

composeFilePath=$1
projectName=$2
backupLocation=$3
action=$4
revertDate=$5

set -e

function backupDatabase {
	dbFile=$1
	volumeName=$2
	location=$3
	dateSuffix=$(date -I)
	
	docker run --rm -v $volumeName:/$dbFile -v $location:/backup ubuntu tar -zcvf /backup/$volumeName.tar /$dbFile

	tar rf backup-$dateSuffix.tar $volumeName.tar
}

function revertDatabase {
	dbFile=$1
	volumeName=$2
	location=$3
	date=$4

	tar -xvf backup-$date.tar $volumeName.tar

	docker run --rm -v $volumeName:/$dbFile ubuntu find /$dbFile -mindepth 1 -delete
	docker run --rm -v $volumeName:/$dbFile -v $location:/backup ubuntu tar -xvf /backup/$volumeName.tar -C .
}

function main {
	if [ $action == "revert" ] 
	then
		docker-compose -f $composeFilePath -p $projectName stop
	fi
	
	volumes=($(docker volume ls -f name=$projectName | awk '{if (NR > 1) print $2}'))
	
	mkdir -p $backupLocation
	cd $backupLocation

	for volume in "${volumes[@]}"  
	do
		dbFile="data"
		if [[ $volume == *"mysql"* ]] 
		then
			dbFile="mysql"
		fi

		echo -e '##\n##' $volume " " $action '\n##'

		if [ $action == "backup" ] 
		then
			backupDatabase $dbFile $volume $backupLocation
		fi

		if [ $action == "revert" ] 
		then
			revertDatabase $dbFile $volume $backupLocation $revertDate
		fi
	
		rm $volume.tar
	done	
}

main
