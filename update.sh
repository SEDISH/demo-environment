#!/bin/sh

COMPOSE='/usr/local/bin/docker-compose'

# Restarts the demo by recreating the docker containers

# Update the compose file
git reset --hard origin/master
git pull

cp config/.env .env

# Restart with new images
$COMPOSE pull
$COMPOSE down
$COMPOSE up --build -d
