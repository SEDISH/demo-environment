#!/bin/sh

if [ -z "$1" ]
   then
     echo "Please enter your ip address"
else
   sudo docker swarm init --advertise-addr $1
   sudo docker stack deploy --compose-file docker-compose.yml demo
fi
