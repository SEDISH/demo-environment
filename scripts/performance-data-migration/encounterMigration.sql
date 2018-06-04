drop procedure if exists encounterMigration;
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

  UPDATE input.encounter_type
    SET creator = admin_id
    WHERE creator IS NOT NULL;

  UPDATE input.encounter_type
    SET retired_by = admin_id
    WHERE retired_by IS NOT NULL;

  call debugMsg(1, 'input updated');

  INSERT INTO encounter_type (name, description, creator, date_created, retired, retired_by,
                              date_retired, retire_reason, uuid, view_privilege, edit_privilege,
                              changed_by, date_changed)
    SELECT name, description, creator, date_created, retired, retired_by, date_retired,
      retire_reason, uuid, view_privilege, edit_privilege, changed_by, date_changed
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

  UPDATE input.encounter
    SET creator = admin_id
    WHERE creator IS NOT NULL;

  UPDATE input.encounter
    SET changed_by = admin_id
    WHERE changed_by IS NOT NULL;

  UPDATE input.encounter
    SET voided_by = admin_id
    WHERE voided_by IS NOT NULL;

  call debugMsg(1, 'input updated');

  INSERT INTO encounter (encounter_type, patient_id, location_id, form_id, encounter_datetime,
                         creator, date_created, voided, voided_by, date_voided, void_reason,
                         changed_by, date_changed, visit_id, uuid)
    SELECT tmp_ent.new_id, tmp_p.new_id, in_en.location_id,
           in_en.form_id, in_en.encounter_datetime, in_en.creator, in_en.date_created, in_en.voided,
           in_en.voided_by, date_voided, void_reason, changed_by, date_changed, tmp_vi.new_id,
           in_en.uuid
    FROM input.encounter in_en
    INNER JOIN tmp_person tmp_p
    ON in_en.patient_id = tmp_p.old_id
    INNER JOIN tmp_encounter_type tmp_ent
    ON in_en.encounter_type = tmp_ent.old_id
    INNER JOIN tmp_visit tmp_vi
    ON in_en.visit_id = tmp_vi.old_id;

 call debugMsg(1, 'encounter inserted');

  UPDATE tmp_encounter tmp, encounter mrs
    SET tmp.new_id = mrs.encounter_id
    WHERE tmp.uuid = mrs.uuid;

  call debugMsg(1, 'tmp_encounter updated');

END $$
DELIMITER ;

