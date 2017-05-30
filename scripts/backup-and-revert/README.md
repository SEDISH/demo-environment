# Backup and revert script

## Backup usage

	./backupRevert.sh pathToDockerCompose dockerProjectName action
	
	Example:

	./backupRevert.sh ./demo-environment/docker-compose.yml demoenvironment backup

## Revert usage

	./backupRevert.sh pathToDockerCompose dockerProjectName action dateOfExistingBackup
	
	Example:

	./backupRevert.sh ./demo-environment/docker-compose.yml demoenvironment revert 2017-05-30

