DELIMITER $$
DROP PROCEDURE IF EXISTS dropTmpTables$$
CREATE PROCEDURE dropTmpTables()
BEGIN

  DROP TABLE IF EXISTS tmp_person;
  DROP TABLE IF EXISTS tmp_person_to_merge;
  DROP TABLE IF EXISTS tmp_person_attribute;
  DROP TABLE IF EXISTS tmp_person_attribute_type;
  DROP TABLE IF EXISTS tmp_patient_id;
  DROP TABLE IF EXISTS tmp_patient_id_type;
  DROP TABLE IF EXISTS tmp_person_name;
  DROP TABLE IF EXISTS tmp_person_address;

  DROP TABLE IF EXISTS tmp_location;
  DROP TABLE IF EXISTS tmp_location_attribute;
  DROP TABLE IF EXISTS tmp_location_attribute_type;
  DROP TABLE IF EXISTS tmp_visit;
  DROP TABLE IF EXISTS tmp_visit_type;

  DROP TABLE IF EXISTS tmp_encounter;
  DROP TABLE IF EXISTS tmp_encounter_type;
  DROP TABLE IF EXISTS tmp_privilege;

  DROP TABLE IF EXISTS tmp_provider;
  DROP TABLE IF EXISTS tmp_provider_attribute;
  DROP TABLE IF EXISTS tmp_provider_attribute_type;
  DROP TABLE IF EXISTS tmp_encounter_role;
  DROP TABLE IF EXISTS tmp_encounter_provider;

  DROP TABLE IF EXISTS tmp_obs;

END $$
DELIMITER ;
