#!/bin/bash
if [ -z "$1" ]
   then
     echo "Please enter name of container"
else
    DHIS_DATA="dhis-data"
    # DHIS: categories
    docker cp $DHIS_DATA/categoryoptioncombo.csv $1:/tmp/categoryoptioncombo.csv 
    docker cp $DHIS_DATA/categorycombo.csv $1:/tmp/categorycombo.csv
    docker cp $DHIS_DATA/dataelementcategoryoption.csv $1:/tmp/dataelementcategoryoption.csv
    docker cp $DHIS_DATA/dataelementcategory.csv $1:/tmp/dataelementcategory.csv
    docker cp $DHIS_DATA/categorycombos_optioncombos.csv $1:/tmp/categorycombos_optioncombos.csv 
    docker cp $DHIS_DATA/categorycombos_categories.csv $1:/tmp/categorycombos_categories.csv
    docker cp $DHIS_DATA/categoryoptioncombos_categoryoptions.csv $1:/tmp/categoryoptioncombos_categoryoptions.csv
    docker cp $DHIS_DATA/categories_categoryoptions.csv $1:/tmp/categories_categoryoptions.csv

    # DHIS: data elements & data sets
    docker cp $DHIS_DATA/dataelement.csv $1:/tmp/dataelement.csv
    docker cp $DHIS_DATA/dataset.csv $1:/tmp/dataset.csv
    docker cp $DHIS_DATA/datasetelement.csv $1:/tmp/datasetelement.csv
    docker cp $DHIS_DATA/datasetsource.csv $1:/tmp/datasetsource.csv

    docker exec $1 /root/copy.sh DHIS && echo "Sets has been added successfully" || echo "Sets loading failed"
fi
