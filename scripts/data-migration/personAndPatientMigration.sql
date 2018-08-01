DROP PROCEDURE IF EXISTS personAndPatientMigration;
DELIMITER $$
CREATE PROCEDURE personAndPatientMigration()
BEGIN
  SET @admin_id = 1;
  SET @code_national_type = (SELECT patient_identifier_type_id
                              FROM input.patient_identifier_type
                              WHERE uuid = '9fb4533d-4fd5-4276-875b-2ab41597f5dd');

  INSERT IGNORE INTO tmp_person_to_merge (new_id, old_id, uuid, code_national)
    SELECT mrs.person_id, in_per.person_id, in_per.uuid, in_pi.identifier
      FROM input.person in_per, input.patient_identifier in_pi,
        (SELECT per.person_id, pi.identifier
           FROM person per, patient_identifier pi
           WHERE per.person_id = pi.patient_id
           AND pi.identifier_type = @code_national_type) as mrs
      WHERE in_per.person_id = in_pi.patient_id
      AND in_pi.identifier_type = @code_national_type
      AND in_pi.identifier = mrs.identifier;

  call debugMsg(1, 'tmp_person_to_merge inserted');

  INSERT INTO tmp_person (old_id, uuid)
    SELECT in_per.person_id, in_per.uuid
      FROM input.person in_per
      WHERE in_per.person_id NOT IN (SELECT old_id FROM tmp_person_to_merge);

  call debugMsg(1, 'tmp_person inserted');

  INSERT INTO person (gender, birthdate, birthdate_estimated, dead, death_date,
    cause_of_death, creator, date_created, changed_by, date_changed, voided, voided_by,
    date_voided, void_reason, uuid, deathdate_estimated, birthtime)
    SELECT gender, birthdate, birthdate_estimated, dead, death_date,
      cause_of_death,
      CASE WHEN creator IS NULL THEN NULL ELSE @admin_id END AS creator,
      date_created,
      CASE WHEN changed_by IS NULL THEN NULL ELSE @admin_id END AS changed_by,
      date_changed, voided,
      CASE WHEN voided_by IS NULL THEN NULL ELSE @admin_id END AS voided_by,
      date_voided, void_reason, in_per.uuid, deathdate_estimated, birthtime
    FROM input.person in_per
    INNER JOIN tmp_person tmp
    ON in_per.person_id = tmp.old_id;

  call debugMsg(1, 'person inserted');

  UPDATE tmp_person tmp, person per
    SET tmp.new_id = per.person_id
    WHERE tmp.uuid = per.uuid;

  call debugMsg(1, 'tmp_person updated');

  INSERT INTO patient (patient_id, creator, date_created, changed_by, date_changed, voided,
    voided_by, date_voided, void_reason)
    SELECT tmp.new_id,
      CASE WHEN creator IS NULL THEN NULL ELSE @admin_id END AS creator,
      p.date_created,
      CASE WHEN changed_by IS NULL THEN NULL ELSE @admin_id END AS changed_by,
      p.date_changed,
      p.voided,
      CASE WHEN voided_by IS NULL THEN NULL ELSE @admin_id END AS voided_by,
      p.date_voided, p.void_reason
    FROM input.patient p
    INNER JOIN tmp_person tmp
    ON p.patient_id = tmp.old_id;

  call debugMsg(1, 'patient inserted');

  call patientIdentifierMigration();
  call personNameMigration();
  call personAddressMigration();
  call personAttributeMigration();

  call mergePerson();

  # Add merged person to tmp_person in order to correctly map all obses, visits etc.
  INSERT INTO tmp_person (new_id, old_id, uuid)
    SELECT new_id, old_id, uuid
      FROM tmp_person_to_merge;

END $$
DELIMITER ;
