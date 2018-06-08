DROP PROCEDURE IF EXISTS encounterMigration;
DELIMITER $$
CREATE PROCEDURE encounterMigration()
BEGIN
  DECLARE admin_id INTEGER DEFAULT 1;

  # privilege migration
  INSERT INTO privilege (privilege, description, uuid)
    SELECT privilege, description, uuid
      FROM input.privilege in_priv
      WHERE NOT EXISTS (
          SELECT out_priv.uuid
          FROM privilege out_priv
          WHERE in_priv.privilege = out_priv.privilege);

  call debugMsg(1, 'privilege done');

  # encounter_type migration
  INSERT INTO tmp_encounter_type (old_id, uuid)
    SELECT encounter_type_id, uuid
    FROM input.encounter_type;

  INSERT INTO encounter_type (`name`, description, creator, date_created, retired, retired_by,
                              date_retired, retire_reason, uuid, view_privilege, edit_privilege,
                              changed_by, date_changed)
    SELECT `name`, description,
      CASE WHEN creator IS NULL THEN NULL ELSE admin_id END AS creator,
      date_created, retired,
      CASE WHEN retired_by IS NULL THEN NULL ELSE admin_id END AS retired_by,
      date_retired, retire_reason, uuid, view_privilege, edit_privilege,
      CASE WHEN changed_by IS NULL THEN NULL ELSE admin_id END AS changed_by,
      date_changed
      FROM input.encounter_type in_et
      WHERE NOT EXISTS (
          SELECT out_et.uuid
          FROM encounter_type out_et
          WHERE in_et.uuid = out_et.uuid);

  UPDATE tmp_encounter_type tmp, encounter_type mrs
    SET tmp.new_id = mrs.encounter_type_id
    WHERE tmp.uuid = mrs.uuid;

  call debugMsg(1, 'encounter_type done');

  # encounter migration
  INSERT INTO tmp_encounter (old_id, uuid)
    SELECT encounter_id, uuid
    FROM input.encounter;

  call debugMsg(1, 'tmp_encounter inserted');

  INSERT INTO encounter (encounter_type, patient_id, location_id, form_id, encounter_datetime,
                         creator, date_created, voided, voided_by, date_voided, void_reason,
                         changed_by, date_changed, uuid)
    SELECT tmp_ent.new_id, tmp_p.new_id, tmp_loc.new_id,
           in_en.form_id, in_en.encounter_datetime,
           CASE WHEN creator IS NULL THEN NULL ELSE admin_id END AS creator,
           in_en.date_created, in_en.voided,
           CASE WHEN voided_by IS NULL THEN NULL ELSE admin_id END AS voided_by,
           date_voided, void_reason,
           CASE WHEN changed_by IS NULL THEN NULL ELSE admin_id END AS changed_by,
           date_changed, in_en.uuid
    FROM input.encounter in_en
    INNER JOIN tmp_person tmp_p
    ON in_en.patient_id = tmp_p.old_id
    INNER JOIN tmp_encounter_type tmp_ent
    ON in_en.encounter_type = tmp_ent.old_id
    LEFT JOIN tmp_location tmp_loc  # left join - entity should be inserted even if location id is Null
    ON in_en.location_id = tmp_loc.old_id;

  call debugMsg(1, 'encounter inserted (except visit_id)');

  UPDATE tmp_encounter tmp, encounter mrs
    SET tmp.new_id = mrs.encounter_id
    WHERE tmp.uuid = mrs.uuid;

  call debugMsg(1, 'tmp_encounter updated');

  UPDATE tmp_encounter tmp_e, encounter mrs, input.encounter in_en, tmp_visit tmp_v
    SET mrs.visit_id = tmp_v.new_id
    WHERE mrs.encounter_id = tmp_e.new_id
          AND tmp_e.old_id = in_en.encounter_id
          AND in_en.visit_id = tmp_v.old_id;

  call debugMsg(1, 'encounter updated with visit_id');

END $$
DELIMITER ;
