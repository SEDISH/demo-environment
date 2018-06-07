drop procedure if exists visitMigration;
DELIMITER $$
CREATE PROCEDURE visitMigration()
BEGIN
  DECLARE admin_id INTEGER DEFAULT 1;

  # visit_type maps types
  INSERT INTO tmp_visit_type (old_id, uuid)
    SELECT visit_type_id, uuid
    FROM input.visit_type;

  INSERT INTO visit_type (name, description, creator, date_created, changed_by, date_changed,
                          retired, retired_by, date_retired, retire_reason, uuid)
    SELECT name, description,
      CASE WHEN creator IS NULL THEN NULL ELSE admin_id END AS creator,
      date_created,
      CASE WHEN changed_by IS NULL THEN NULL ELSE admin_id END AS changed_by,
      date_changed, retired,
      CASE WHEN retired_by IS NULL THEN NULL ELSE admin_id END AS retired_by,
      date_retired, retire_reason, uuid
      FROM input.visit_type in_vt
      WHERE NOT EXISTS (
          SELECT out_vt.uuid
          FROM visit_type out_vt
          WHERE in_vt.uuid = out_vt.uuid);

  UPDATE tmp_visit_type tmp, visit_type mrs
    SET tmp.new_id = mrs.visit_type_id
    WHERE tmp.uuid = mrs.uuid;

  call debugMsg(1, 'tmp_visit_type done');

  # Locations between two versions of databases contains the same data and all location_id matches,
  # so there is no need to insert them from the input database
  # Locations can be inserted via UI, so they have different uuids.

  # visit migration
  INSERT INTO tmp_visit (old_id, uuid)
    SELECT visit_id, uuid
    FROM input.visit;

  call debugMsg(1, 'tmp_visit inserted');

  INSERT INTO visit (patient_id, visit_type_id, date_started, date_stopped,
    indication_concept_id, location_id, creator, date_created, changed_by,
    date_changed, voided, voided_by, date_voided, void_reason, uuid)
    SELECT tmp_person.new_id, tmp_visit_type.new_id, v.date_started, v.date_stopped,
      v.indication_concept_id, location_id,
      CASE WHEN creator IS NULL THEN NULL ELSE admin_id END AS creator,
      v.date_created,
      CASE WHEN changed_by IS NULL THEN NULL ELSE admin_id END AS changed_by,
      v.date_changed, v.voided,
      CASE WHEN voided_by IS NULL THEN NULL ELSE admin_id END AS voided_by,
      v.date_voided, v.void_reason, v.uuid
    FROM input.visit v
    LEFT JOIN tmp_person
    ON v.patient_id = tmp_person.old_id
    LEFT JOIN tmp_visit_type
    ON v.visit_type_id = tmp_visit_type.old_id;

  call debugMsg(1, 'visit inserted');

  UPDATE tmp_visit tmp, visit mrs
    SET tmp.new_id = mrs.visit_id
    WHERE tmp.uuid = mrs.uuid;

  call debugMsg(1, 'tmp_visit updated');

END $$
DELIMITER ;

