# Backup and revert script for SEDISH databases

## Backup usage

	./backupRevert.sh {pathToDockerCompose} {dockerProjectName} {backupDestination} {action}

	Example:

	./backupRevert.sh ./demo-environment/docker-compose.yml demoenvironment ~/workspace/backup/ backup

## Revert usage

	./backupRevert.sh {pathToDockerCompose} {dockerProjectName} {backupLocation} {action} {dateOfExistingBackup}

	Example:

	./backupRevert.sh ./demo-environment/docker-compose.yml demoenvironment ~/workspace/backup/ revert 2017-05-30_170702

# Backup and revert script for IsantePlus local instance

## Backup usage

	./isanteplusBackupAndRevert.sh {databaseUsername} {databasePassword} {backupDestination} backup

	Example:

	./isanteplusBackupAndRevert.sh root s3cr3t ~/backup/ backup

## Revert usage

	./isanteplusBackupAndRevert.sh {databaseUsername} {databasePassword} {backupDestination} revert {dateOfExistingBackup}

	Example:

	./isanteplusBackupAndRevert.sh root s3cr3t ~/backup/ revert 2018-05-29*
