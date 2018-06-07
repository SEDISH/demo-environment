drop procedure if exists patientIdentifierMigration;
DELIMITER $$
CREATE PROCEDURE patientIdentifierMigration()
BEGIN
  DECLARE admin_id INTEGER DEFAULT 1;

  INSERT INTO tmp_patient_id (old_id, uuid)
    SELECT patient_identifier_id, uuid
    FROM input.patient_identifier;

  call debugMsg(1, 'tmp_patient_id inserted');

  INSERT INTO patient_identifier (patient_id, identifier, identifier_type, preferred, location_id,
                                  creator, date_created, date_changed, changed_by, voided,
                                  voided_by, date_voided, void_reason, uuid)
    SELECT patient.new_id, identifier, identifier_type, preferred, location_id,
      CASE WHEN creator IS NULL THEN NULL ELSE admin_id END AS creator,
      date_created, date_changed,
      CASE WHEN changed_by IS NULL THEN NULL ELSE admin_id END AS changed_by,
      voided,
      CASE WHEN voided_by IS NULL THEN NULL ELSE admin_id END AS voided_by,
      date_voided, void_reason, pi.uuid
    FROM input.patient_identifier AS pi
    INNER JOIN tmp_person AS patient
    ON pi.patient_id = patient.old_id;

  call debugMsg(1, 'patient_identifier inserted');

  UPDATE tmp_patient_id tmp, patient_identifier per
    SET tmp.new_id = per.patient_identifier_id
    WHERE tmp.uuid = per.uuid;

  call debugMsg(1, 'tmp_patient_id updated');

END $$
DELIMITER ;
