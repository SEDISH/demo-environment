DROP PROCEDURE IF EXISTS encounterProviderMigration;
DELIMITER $$
CREATE PROCEDURE encounterProviderMigration()
BEGIN
  SET @admin_id = 1;

  INSERT INTO tmp_encounter_role (old_id, uuid)
    SELECT encounter_role_id, uuid
    FROM input.encounter_role;

  INSERT INTO encounter_role (`name`, `description`, creator, date_created, changed_by, date_changed, retired, retired_by,
                              date_retired, retire_reason, uuid)
    SELECT `name`, `description`,
      CASE WHEN creator IS NULL THEN NULL ELSE @admin_id END AS creator,
      date_created,
      CASE WHEN changed_by IS NULL THEN NULL ELSE @admin_id END AS changed_by,
      date_changed, retired,
      CASE WHEN retired_by IS NULL THEN NULL ELSE @admin_id END AS retired_by,
      date_retired, retire_reason, uuid
      FROM input.encounter_role in_enc_role
      WHERE in_enc_role.uuid NOT IN (SELECT mrs.uuid
                                      FROM encounter_role mrs
                                      WHERE in_enc_role.uuid = mrs.uuid);

  UPDATE tmp_encounter_role tmp, encounter_role mrs
    SET tmp.new_id = mrs.encounter_role_id
    WHERE tmp.uuid = mrs.uuid;

  call debugMsg(1, 'encounter_role done');

  INSERT INTO tmp_encounter_provider (old_id, uuid)
    SELECT encounter_provider_id, uuid
    FROM input.encounter_provider;

  call debugMsg(1, 'tmp_encounter_provider inserted');

  INSERT INTO encounter_provider (encounter_id, provider_id, encounter_role_id, creator, date_created, changed_by,
                                  date_changed, voided, date_voided, voided_by, void_reason, uuid)
    SELECT tmp_enc.new_id, tmp_prov.new_id, tmp_enc_role.new_id,
      CASE WHEN creator IS NULL THEN NULL ELSE @admin_id END AS creator,
      date_created,
      CASE WHEN changed_by IS NULL THEN NULL ELSE @admin_id END AS changed_by,
      date_changed, voided, date_voided,
      CASE WHEN voided_by IS NULL THEN NULL ELSE @admin_id END AS voided_by,
      void_reason, in_enc_prov.uuid
    FROM input.encounter_provider in_enc_prov
    INNER JOIN tmp_encounter tmp_enc
    ON in_enc_prov.encounter_id = tmp_enc.old_id
    INNER JOIN tmp_provider tmp_prov
    ON in_enc_prov.provider_id = tmp_prov.old_id
    INNER JOIN tmp_encounter_role tmp_enc_role
    ON in_enc_prov.encounter_role_id = tmp_enc_role.old_id
    WHERE in_enc_prov.uuid NOT IN (SELECT mrs.uuid
                                    FROM encounter_provider mrs);

  call debugMsg(1, 'encounter_provider inserted');

  UPDATE tmp_encounter_provider tmp, encounter_provider mrs
    SET tmp.new_id = mrs.encounter_provider_id
    WHERE tmp.uuid = mrs.uuid;

  call debugMsg(1, 'tmp_encounter_provider updated');

END $$
DELIMITER ;
