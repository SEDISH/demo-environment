#!/bin/bash

if [ $# -eq 0 ]; then
    server="https://localhost:8080";
elif [ $# -eq 1 ]; then
    server=https://$1;
else
    exit 1;
fi

echo $server

username=root@openhim.org;
pass=openhim-password;

auth=`curl -k -s $server/authenticate/$username`;
salt=`echo $auth | perl -pe 's|.*"salt":"(.*?)".*|\1|'`;
ts=`echo $auth | perl -pe 's|.*"ts":"(.*?)".*|\1|'`;

passhash=`echo -n "$salt$pass" | shasum -a 512 | awk '{print $1}'`;
token=`echo -n "$passhash$salt$ts" | shasum -a 512 | awk '{print $1}'`;

curl $server/clients -k -d @./conf/openInfoManClient.json -X POST -H "Content-Type:application/json" -H "auth-username: $username" -H "auth-ts: $ts" -H "auth-salt: $salt" -H "auth-token: $token";

curl $server/channels -k -d @./conf/openInfoManChannel.json -X POST -H "Content-Type:application/json" -H "auth-username: $username" -H "auth-ts: $ts" -H "auth-salt: $salt" -H "auth-token: $token";
