#!/bin/bash

composeFilePath=$1
projectName=$2
action=$3
revertDate=$4

set -e

function backupDatabase {
	dbFile=$1
	volumeName=$2
	dateSuffix=$(date -I)
	
	docker run --rm -v $volumeName:/$dbFile -v $(pwd)/backup/$volumeName/$dateSuffix:/backup ubuntu tar -zcvf /backup/$volumeName-$dateSuffix.tar /$dbFile
}

function revertDatabase {
	dbFile=$1
	volumeName=$2
	date=$3

	docker run --rm -v $volumeName:/$dbFile ubuntu find /$dbFile -mindepth 1 -delete
	docker run --rm -v $volumeName:/$dbFile -v $(pwd)/backup/$volumeName/$date:/backup ubuntu tar -xvf /backup/$volumeName-$date.tar -C .
}

function main {
	docker-compose -f $composeFilePath -p $projectName stop
	volumes=($(docker volume ls -f name=$projectName | awk '{if (NR > 1) print $2}'))

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
			backupDatabase $dbFile $volume
		fi

		if [ $action == "revert" ] 
		then
			revertDatabase $dbFile $volume $revertDate
		fi
	done
}

main
