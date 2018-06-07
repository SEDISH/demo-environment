DROP PROCEDURE IF EXISTS personAndPatientMigration;
DELIMITER $$
CREATE PROCEDURE personAndPatientMigration()
BEGIN
  DECLARE admin_id INTEGER DEFAULT 1;
  DECLARE isante_plus_id_type INTEGER DEFAULT 5;

  INSERT INTO tmp_person (old_id, uuid, isante_plus_id)
    SELECT pa.person_id, pa.uuid, pi.identifier
      FROM input.person pa, input.patient_identifier pi
      WHERE pa.person_id = pi.patient_id
      AND pi.identifier_type = isante_plus_id_type
      AND pi.identifier NOT IN (SELECT pi.identifier
                                  FROM openmrs.patient_identifier pi
                                  WHERE pi.identifier_type = isante_plus_id_type);

  call debugMsg(1, 'tmp_person inserted');

  INSERT INTO tmp_person (old_id, uuid, isante_plus_id)
    SELECT pa.person_id, pa.uuid, pi.identifier
      FROM input.person pa, input.patient_identifier pi
      WHERE pa.person_id = pi.patient_id
      AND pi.identifier_type = isante_plus_id_type
      AND pi.identifier IN (SELECT pi.identifier
                                  FROM openmrs.patient_identifier pi
                                  WHERE pi.identifier_type = isante_plus_id_type);

  call debugMsg(1, 'tmp_person_to_merge inserted');

  INSERT INTO person (gender, birthdate, birthdate_estimated, dead, death_date,
    cause_of_death, creator, date_created, changed_by, date_changed, voided, voided_by,
    date_voided, void_reason, uuid, deathdate_estimated, birthtime)
    SELECT gender, birthdate, birthdate_estimated, dead, death_date,
      cause_of_death,
      CASE WHEN creator IS NULL THEN NULL ELSE admin_id END AS creator,
      date_created,
      CASE WHEN changed_by IS NULL THEN NULL ELSE admin_id END AS changed_by,
      date_changed, voided,
      CASE WHEN voided_by IS NULL THEN NULL ELSE admin_id END AS voided_by,
      date_voided, void_reason, uuid, deathdate_estimated, birthtime
    FROM input.person;

  call debugMsg(1, 'person inserted');

  UPDATE tmp_person tmp, person per
    SET tmp.new_id = per.person_id
    WHERE tmp.uuid = per.uuid;

  call debugMsg(1, 'tmp_person updated');

  UPDATE tmp_person_to_merge tmp,
    (SELECT per.person_id, pi.identifier
     FROM person per, patient_identifier pi
       WHERE per.person_id = pi.patient_id) mrs_person
    SET tmp.new_id = mrs_person.person_id
    WHERE tmp.isante_plus_id = mrs_person.identifier;

  call debugMsg(1, 'tmp_person_to_merge updated');

  INSERT INTO patient (patient_id, creator, date_created, changed_by, date_changed, voided,
    voided_by, date_voided, void_reason)
    SELECT tmp.new_id,
      CASE WHEN creator IS NULL THEN NULL ELSE admin_id END AS creator,
      p.date_created,
      CASE WHEN changed_by IS NULL THEN NULL ELSE admin_id END AS changed_by,
      p.date_changed,
      p.voided,
      CASE WHEN voided_by IS NULL THEN NULL ELSE admin_id END AS voided_by,
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

END $$
DELIMITER ;
