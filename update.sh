#!/bin/sh

COMPOSE='/usr/local/bin/docker-compose'

# Restarts the demo by recreating the docker containers

# Update the compose file
git reset --hard origin/master
git pull

cp conf/.env .env
../conf.sh .env

# Restart with new images
$COMPOSE pull
$COMPOSE down
$COMPOSE rm -v

# Remove unnamed volumes
docker volume list | grep -v demoenvironment | awk '{print $2}' | xargs docker volume rm

$COMPOSE up -d
