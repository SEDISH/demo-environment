DROP PROCEDURE IF EXISTS providerAttributeMigration;
DELIMITER $$
CREATE PROCEDURE providerAttributeMigration()
BEGIN
  SET @admin_id = 1;

  INSERT INTO tmp_provider_attribute_type (old_id, uuid)
    SELECT provider_attribute_type_id, uuid
    FROM input.provider_attribute_type;

  INSERT INTO provider_attribute_type (`name`, description, datatype, datatype_config, preferred_handler, handler_config,
                                       min_occurs, max_occurs, creator, date_created, changed_by, date_changed, retired,
                                       retired_by, date_retired, retire_reason, uuid)
    SELECT `name`, description, datatype, datatype_config, preferred_handler, handler_config,
      min_occurs, max_occurs,
      CASE WHEN creator IS NULL THEN NULL ELSE @admin_id END AS creator,
      date_created,
      CASE WHEN changed_by IS NULL THEN NULL ELSE @admin_id END AS changed_by,
      date_changed, retired,
      CASE WHEN retired_by IS NULL THEN NULL ELSE @admin_id END AS retired_by,
      date_retired,
      retire_reason, uuid
      FROM input.provider_attribute_type in_prov_attr_t
      WHERE in_prov_attr_t.uuid NOT IN (SELECT mrs.uuid
                                        FROM provider_attribute_type mrs
                                        WHERE in_prov_attr_t.uuid = mrs.uuid);

  UPDATE tmp_provider_attribute_type tmp, provider_attribute_type mrs
    SET tmp.new_id = mrs.provider_attribute_type_id
    WHERE tmp.uuid = mrs.uuid;

  call debugMsg(1, 'provider_attribute_type done');

  INSERT INTO tmp_provider_attribute (old_id, uuid)
    SELECT provider_attribute_id, uuid
    FROM input.provider_attribute;

  call debugMsg(1, 'tmp_provider_attribute inserted');

  INSERT INTO provider_attribute (provider_id, attribute_type_id, value_reference, uuid, creator, date_created, changed_by,
                                  date_changed, voided, voided_by, date_voided, void_reason)
    SELECT tmp_prov.new_id, tmp_prov_attr_t.new_id, value_reference, in_prov_attr.uuid,
      CASE WHEN creator IS NULL THEN NULL ELSE @admin_id END AS creator,
      date_created,
      CASE WHEN changed_by IS NULL THEN NULL ELSE @admin_id END AS changed_by,
      date_changed, voided,
      CASE WHEN voided_by IS NULL THEN NULL ELSE @admin_id END AS voided_by,
      date_voided, void_reason
    FROM input.provider_attribute in_prov_attr
    INNER JOIN tmp_provider tmp_prov
    ON in_prov_attr.provider_id = tmp_prov.old_id
    INNER JOIN tmp_provider_attribute_type tmp_prov_attr_t
    ON in_prov_attr.attribute_type_id = tmp_prov_attr_t.old_id
    WHERE in_prov_attr.uuid NOT IN (SELECT mrs.uuid
                                    FROM provider_attribute mrs);

  call debugMsg(1, 'provider_attribute inserted');

  UPDATE tmp_provider_attribute tmp, provider_attribute mrs
    SET tmp.new_id = mrs.provider_attribute_id
    WHERE tmp.uuid = mrs.uuid;

  call debugMsg(1, 'tmp_provider_attribute updated');

END $$
DELIMITER ;
