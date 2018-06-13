#!/bin/bash
databaseUsername=$1
databasePassword=$2
backupLocation=$3
action=$4
revertDateOrBucket=$5

set -e

function backupDatabase {
	dbName=$1
	backupTime=$2
  fileName=$dbName-dump-$backupTime.sql

  mysqldump -u$databaseUsername -p$databasePassword --databases $dbName --add-drop-database > $fileName

  tar rf openmrsBackup-$backupTime.tar $fileName
  rm $fileName
}

function uploadToAWSBacket{
  backupTime=$1

  fileToUpload="openmrsBackup-$backupTime.tar"

  export AWS_PROFILE="default"
  export AWS_CONFIG_FILE=$(pwd)/aws_config

  aws s3 cp $fileToUpload s3://$revertDateOrBucket/
}

function revertDatabase {
	date=$1

	for i in $(tar -xvf openmrsBackup-$date.tar)
	do
		mysql -u$databaseUsername -p$databasePassword < $i
		rm $i
	done
}

function main {
	mkdir -p $backupLocation
	cd $backupLocation

  if [ $action == "backup" ]
  then
    backupTime=$(date +%F_%H%M%S)
    backupDatabase openmrs $backupTime
    backupDatabase isanteplus $backupTime
    uploadToAWSBacket $backupTime
  fi

  if [ $action == "revert" ]
  then
    revertDatabase $revertDateOrBucket
  fi
}

main
