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
    `code_national` varchar(50) UNIQUE,
    `uuid` char(38) NOT NULL);

  CREATE TABLE `tmp_person_attribute` (
    `old_id` int(11) NOT NULL,
    `new_id` int(11),
    `uuid` char(38) NOT NULL);

  CREATE TABLE `tmp_person_attribute_type` (
    `old_id` int(11) NOT NULL,
    `new_id` int(11),
    `uuid` char(38) NOT NULL);

  CREATE TABLE `tmp_patient_id_type` (
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

  CREATE TABLE `tmp_location` (
      `old_id` int(11) NOT NULL,
      `new_id` int(11),
      `name` varchar(255) NOT NULL);

  CREATE TABLE `tmp_location_attribute` (
      `old_id` int(11) NOT NULL,
      `new_id` int(11),
      `value_reference` text NOT NULL);

  CREATE TABLE `tmp_location_attribute_type` (
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

  CREATE TABLE `tmp_provider` (
    `old_id` int(11) NOT NULL,
    `new_id` int(11),
    `uuid` char(38) NOT NULL);

  CREATE TABLE `tmp_provider_attribute` (
    `old_id` int(11) NOT NULL,
    `new_id` int(11),
    `uuid` char(38) NOT NULL);

  CREATE TABLE `tmp_provider_attribute_type` (
    `old_id` int(11) NOT NULL,
    `new_id` int(11),
    `uuid` char(38) NOT NULL);

  CREATE TABLE `tmp_encounter_role` (
    `old_id` int(11) NOT NULL,
    `new_id` int(11),
    `uuid` char(38) NOT NULL);

  CREATE TABLE `tmp_encounter_provider` (
    `old_id` int(11) NOT NULL,
    `new_id` int(11),
    `uuid` char(38) NOT NULL);

  CREATE TABLE `tmp_obs` (
    `old_id` int(11) NOT NULL,
    `new_id` int(11),
    `uuid` char(38) NOT NULL);

  CREATE TABLE `tmp_user` (
    `old_id` int(11) NOT NULL,
    `new_id` int(11),
    `uuid` char(38) NOT NULL,
    `is_new` BIT DEFAULT 1,
    `merged` BIT DEFAULT 0);

  CREATE TABLE `tmp_user_to_merge` (
    `old_id` int(11) NOT NULL,
    `new_id` int(11),
    `uuid` char(38) NOT NULL,
    `merged` BIT DEFAULT 0);

END $$
DELIMITER ;
