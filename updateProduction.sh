#!/bin/sh

COMPOSE='/usr/local/bin/docker-compose'

# Restart with new images
$COMPOSE pull
$COMPOSE down
$COMPOSE rm -v

$COMPOSE up -d

echo "Finished updating the Sedish Demo at: `date`"
