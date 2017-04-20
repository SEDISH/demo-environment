#!/bin/bash

if [ -z "$1" ]
   then
     echo "Please enter name of container"
else
   docker cp fields_values.csv $1:/tmp/fields_values.csv
   docker cp attributes.csv $1:/tmp/attributes.csv
   docker cp organisationunitattributevalues.csv $1:/tmp/organisationunitattributevalues.csv
   docker cp facilities.csv $1:/tmp/facilities.csv
   docker exec $1 /root/copy.sh && echo "Facilities updated succesfully" || echo "Facilites update failed"
fi
