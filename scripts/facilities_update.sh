#!/bin/bash

if [ -z "$1" ]
   then
     echo "Please enter name of container"
else
   if [[ $2 =~ ^[Ff][Rr] ]]; then
      #FR
      docker cp fields_values.csv $1:/tmp/fields_values.csv
      docker cp attributes.csv $1:/tmp/attributes.csv
      docker cp organisationunitattributevalues.csv $1:/tmp/organisationunitattributevalues.csv
      docker cp facilities.csv $1:/tmp/facilities.csv
      docker cp orgunitgroup.csv $1:/tmp/orgunitgroup.csv
      docker cp orgunitgroupmembers.csv $1:/tmp/orgunitgroupmembers.csv
      docker exec $1 /root/copy.sh FR && echo "Facilities updated succesfully" || echo "Facilites update failed"
   elif [[ $2 =~ ^[Hh][Ww][Rr] ]]; then
      #HWR
      docker cp userAttributeValues.csv $1:/tmp/userAttributeValues.csv
      docker cp users.csv $1:/tmp/users.csv
      docker cp userInfo.csv $1:/tmp/userInfo.csv
      docker cp userMembership.csv $1:/tmp/userMembership.csv
      docker cp userRoleAuthorities.csv $1:/tmp/userRoleAuthorities.csv
      docker cp userRoleMembers.csv $1:/tmp/userRoleMembers.csv
      docker cp userSetting.csv $1:/tmp/userSetting.csv
      docker cp userRole.csv $1:/tmp/userRole.csv
      docker exec $1 /root/copy.sh HWR && echo "Health worker updated succesfully" || echo "Health worker update failed"
   elif [[ $2 =~ ^[Xx][Dd][Ss][Ss][Aa][Mm][Pp][Ll][Ee] ]]; then
      #XDSSample
      docker cp XDSDocTest.sql $1:/tmp/XDSDocTest.sql
      docker exec $1 /root/copy.sh XDSSample && echo "XDSSample updated succesfully" || echo "XDSSample update failed"
   elif [[ $2 =~ ^[Ee][Tt][Ll] ]]; then
      #ETLDatabase
      sudo docker exec $1 -d dhis2 -U postgres -c "create database etl" && echo "ETL Database created succesfully" || echo "ETL Database was not created"
   else
      echo "Unknown parameter: $2"
   fi
fi
