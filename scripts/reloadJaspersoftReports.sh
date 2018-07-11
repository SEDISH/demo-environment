#!/bin/bash
if [ -z "$2" ]; then
     echo "Example usage: ./reloadJaspersoftReports.sh <nameOfOhieFrContainer> <nameOfFrDBContainer>";
     exit;
fi

OHIE_FR=$1
FR_DB=$2

docker exec $FR_DB /root/removeReportFromDhis.sh

docker exec $OHIE_FR /sendReports.sh
