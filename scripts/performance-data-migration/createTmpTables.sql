DELIMITER $$
DROP PROCEDURE IF EXISTS createTmpTables$$
CREATE PROCEDURE createTmpTables()
BEGIN

  CREATE TABLE `tmp_person` (
    `old_id` int(11) NOT NULL,
    `new_id` int(11),
    `uuid` char(38) NOT NULL);

  CREATE TABLE `tmp_person_to_merge` (
    `old_id` int(11) NOT NULL,
    `new_id` int(11),
    `code_national` varchar(50),
    `uuid` char(38) NOT NULL);

  CREATE TABLE `tmp_person_attribute` (
    `old_id` int(11) NOT NULL,
    `new_id` int(11),
    `uuid` char(38) NOT NULL);

  CREATE TABLE `tmp_person_attribute_type` (
    `old_id` int(11) NOT NULL,
    `new_id` int(11),
    `uuid` char(38) NOT NULL);

    CREATE TABLE `tmp_patient_id` (
    `old_id` int(11) NOT NULL,
    `new_id` int(11),
    `uuid` char(38) NOT NULL);

    CREATE TABLE `tmp_person_name` (
    `old_id` int(11) NOT NULL,
    `new_id` int(11),
    `uuid` char(38) NOT NULL);

  CREATE TABLE `tmp_person_address` (
    `old_id` int(11) NOT NULL,
    `new_id` int(11),
    `uuid` char(38) NOT NULL);

    CREATE TABLE `tmp_visit_type` (
    `old_id` int(11) NOT NULL,
    `new_id` int(11),
    `uuid` char(38) NOT NULL);

  CREATE TABLE `tmp_visit` (
    `old_id` int(11) NOT NULL,
    `new_id` int(11),
    `uuid` char(38) NOT NULL);

  CREATE TABLE `tmp_privilege` (
    `old_id` varchar(255) NOT NULL,
    `new_id` varchar(255),
    `uuid` char(38) NOT NULL);

    CREATE TABLE `tmp_encounter_type` (
    `old_id` int(11) NOT NULL,
    `new_id` int(11),
    `uuid` char(38) NOT NULL);

  CREATE TABLE `tmp_encounter` (
    `old_id` int(11) NOT NULL,
    `new_id` int(11),
    `uuid` char(38) NOT NULL);

  CREATE TABLE `tmp_obs` (
    `old_id` int(11) NOT NULL,
    `new_id` int(11),
    `uuid` char(38) NOT NULL);

END $$
DELIMITER ;
