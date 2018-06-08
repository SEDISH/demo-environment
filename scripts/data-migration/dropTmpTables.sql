DELIMITER $$
DROP PROCEDURE IF EXISTS dropTmpTables$$
CREATE PROCEDURE dropTmpTables()
BEGIN

  DROP TABLE tmp_person;
  DROP TABLE tmp_person_to_merge;
  DROP TABLE tmp_person_attribute;
  DROP TABLE tmp_person_attribute_type;
  DROP TABLE tmp_patient_id;
  DROP TABLE tmp_patient_id_type;
  DROP TABLE tmp_person_name;
  DROP TABLE tmp_person_address;

  DROP TABLE tmp_location;
  DROP TABLE tmp_location_attribute;
  DROP TABLE tmp_location_attribute_type;
  DROP TABLE tmp_visit;
  DROP TABLE tmp_visit_type;

  DROP TABLE tmp_encounter;
  DROP TABLE tmp_encounter_type;
  DROP TABLE tmp_privilege;

  DROP TABLE tmp_provider;

  DROP TABLE tmp_obs;

END $$
DELIMITER ;
