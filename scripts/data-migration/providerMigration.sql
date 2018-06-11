DROP PROCEDURE IF EXISTS providerMigration;
DELIMITER $$
CREATE PROCEDURE providerMigration()
BEGIN
  SET @admin_id = 1;

  INSERT INTO tmp_provider (old_id, uuid)
    SELECT provider_id, uuid
    FROM input.provider;

  call debugMsg(1, 'tmp_location_attribute inserted');

  INSERT INTO provider (person_id, `name`, identifier, creator, date_created, changed_by, date_changed, retired, retired_by,
                       date_retired, retire_reason, uuid)
    SELECT tmp_per.new_id, `name`, identifier,
      CASE WHEN creator IS NULL THEN NULL ELSE @admin_id END AS creator,
      date_created,
      CASE WHEN changed_by IS NULL THEN NULL ELSE @admin_id END AS changed_by,
      date_changed, retired,
      CASE WHEN retired_by IS NULL THEN NULL ELSE @admin_id END AS retired_by,
      date_retired, retire_reason, in_prov.uuid
    FROM input.provider in_prov
    INNER JOIN tmp_person tmp_per
    ON in_prov.person_id = tmp_per.old_id
    WHERE in_prov.uuid NOT IN (SELECT mrs.uuid
                              FROM provider mrs);

  call debugMsg(1, 'provider inserted');

  UPDATE tmp_provider tmp, provider mrs
    SET tmp.new_id = mrs.provider_id
    WHERE tmp.uuid = mrs.uuid;

  call debugMsg(1, 'tmp_provider updated');

  call encounterProviderMigration();
  call providerAttributeMigration();

END $$
DELIMITER ;
