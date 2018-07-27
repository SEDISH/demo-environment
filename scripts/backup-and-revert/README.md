# Backup and revert script for SEDISH databases

## Before using

	1) Install AWS CLI:
		sudo apt-get install -y --force-yes python2.7
		sudo apt-get install -y --force-yes python-pip
		sudo apt-get install awscli

	2) Update the aws_config file with your credentials.



## Backup usage

	./backupRevert.sh {pathToDockerCompose} {dockerProjectName} {backupDestination} backup {bucket}

	Example:

	./backupRevert.sh ./demo-environment/docker-compose.yml demoenvironment ~/workspace/backup/ backup sedish-bucket

## Revert usage

	./backupRevert.sh {pathToDockerCompose} {dockerProjectName} {backupLocation} revert {dateOfExistingBackup}

	Example:

	./backupRevert.sh ./demo-environment/docker-compose.yml demoenvironment ~/workspace/backup/ revert 2017-05-30_170702

# Backup and revert script for IsantePlus local instance

## Backup usage

	./isanteplusBackupAndRevert.sh {databaseUsername} {databasePassword} {backupDestination} backup {bucket}

	Example:

	./isanteplusBackupAndRevert.sh root s3cr3t ~/backup/ backup sedish-bucket

## Revert usage

	./isanteplusBackupAndRevert.sh {databaseUsername} {databasePassword} {backupDestination} revert {dateOfExistingBackup}

	Example:

	./isanteplusBackupAndRevert.sh root s3cr3t ~/backup/ revert 2018-05-29*
