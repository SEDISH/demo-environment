#!/bin/sh

# Restarts the demo by recreating the docker containers

# Update the compose file
git reset --hard origin/master
git pull


# Restart with new images
docker-compose down
docker-compose up --build -d
