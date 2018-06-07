OpenMRS 2.0.x to OpenMRS 1.12.0 data migration script
=====================================================
This repository contains sql queries to migrate data from an existing OpenMRS Platform 2.0.x
database to the OpenMRS Platform 1.12.0 that is based on the OpenMRS data model.

The target database have to be named 'openmrs'. The OpenMRS 2.0.x database have to be imported with
a name: 'input'. Before the migration all stored procedures (corresponding to each SQL file) 
have to be created in the OpenMRS 1.12.0 database (named 'openmrs').
<br>
<br>

    use openmrs;
    call migrationSHR();
