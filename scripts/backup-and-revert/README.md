# Backup and revert script

## Backup usage

	./backupRevert.sh {pathToDockerCompose} {dockerProjectName} {backupDestination} {action}
	
	Example:

	./backupRevert.sh ./demo-environment/docker-compose.yml demoenvironment ~/workspace/backup/ backup

## Revert usage

	./backupRevert.sh {pathToDockerCompose} {dockerProjectName} {backupLocation} {action} {dateOfExistingBackup}
	
	Example:

	./backupRevert.sh ./demo-environment/docker-compose.yml demoenvironment ~/workspace/backup/ revert 2017-05-30

