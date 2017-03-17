#!/bin/sh

COMPOSE='/usr/local/bin/docker-compose'

# Restarts the demo by recreating the docker containers

# Update the compose file
git reset --hard origin/master
git pull


# Restart with new images
$COMPOSE down
$COMPOSE up --build -d
