#!/bin/bash

composeFilePath=$1
projectName=$2
backupLocation=$3
action=$4
revertDateOrBucket=$5

set -e

function backupDatabase {
	dbFile=$1
	volumeName=$2
	location=$3
	backupTime=$4

	docker run --rm -v $volumeName:/$dbFile -v $location:/backup ubuntu tar -zcvf /backup/$volumeName.tar /$dbFile

	tar rf backup-$backupTime.tar $volumeName.tar --force-local
}

function revertDatabase {
	dbFile=$1
	volumeName=$2
	location=$3
	date=$4

	tar -xvf backup-$date.tar $volumeName.tar --force-local

	docker run --rm -v $volumeName:/$dbFile ubuntu find /$dbFile -mindepth 1 -delete
	docker run --rm -v $volumeName:/$dbFile -v $location:/backup ubuntu tar -xvf /backup/$volumeName.tar -C .
}

function main {
	if [ $action == "revert" ]
	then
		docker-compose -f $composeFilePath -p $projectName stop
	else
		backupTime=$(date +%F_%H%M%S)
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
			backupDatabase $dbFile $volume $backupLocation $backupTime
		fi

		if [ $action == "revert" ]
		then
			revertDatabase $dbFile $volume $backupLocation $revertDateOrBucket
		fi

		rm -f $volume.tar
	done

	if [ $action == "revert" ]
	then
		docker-compose -f $composeFilePath -p $projectName up -d
	else
        fileToUpload="backup-$backupTime.tar"

        export AWS_PROFILE="default"
        export AWS_CONFIG_FILE=$(pwd)/aws_config

        aws s3 cp $fileToUpload s3://$revertDateOrBucket/
	fi
}

main
