DROP PROCEDURE IF EXISTS locationAttributeMigration;
DELIMITER $$
CREATE PROCEDURE locationAttributeMigration()
BEGIN
  DECLARE admin_id INTEGER DEFAULT 1;

  INSERT INTO tmp_location_attribute_type (old_id, uuid)
    SELECT location_attribute_type_id, uuid
    FROM input.location_attribute_type;

  INSERT INTO location_attribute_type (`name`, description, datatype, datatype_config, preferred_handler, handler_config,
                                      min_occurs, max_occurs, creator, date_created, changed_by, date_changed, retired,
                                      retired_by, date_retired, retire_reason, uuid)
    SELECT `name`, description, datatype, datatype_config, preferred_handler, handler_config, min_occurs, max_occurs,
      CASE WHEN creator IS NULL THEN NULL ELSE admin_id END AS creator,
      date_created,
      CASE WHEN changed_by IS NULL THEN NULL ELSE admin_id END AS changed_by,
      date_changed, retired,
      CASE WHEN retired_by IS NULL THEN NULL ELSE admin_id END AS retired_by,
      date_retired, retire_reason, in_loct.uuid
      FROM input.location_attribute_type in_loct
      WHERE NOT EXISTS (
          SELECT mrs.uuid
          FROM location_attribute_type mrs
          WHERE in_loct.uuid = mrs.uuid);

  UPDATE tmp_location_attribute_type tmp, location_attribute_type mrs
    SET tmp.new_id = mrs.location_attribute_type_id
    WHERE tmp.uuid = mrs.uuid;

  call debugMsg(1, 'location_attribute_type done');

  INSERT INTO tmp_location_attribute (old_id, value_reference)
    SELECT location_attribute_id, value_reference
    FROM input.location_attribute;

  call debugMsg(1, 'tmp_location_attribute inserted');

  INSERT INTO location_attribute (location_id, attribute_type_id, value_reference, creator, uuid, date_created, changed_by,
                                 date_changed, voided, voided_by, date_voided, void_reason)
    SELECT tmp_loc.new_id, tmp_loct.new_id, value_reference,
      CASE WHEN creator IS NULL THEN NULL ELSE admin_id END AS creator,
      in_loc_att.uuid, date_created,
      CASE WHEN changed_by IS NULL THEN NULL ELSE admin_id END AS changed_by,
      date_changed, voided,
      CASE WHEN voided_by IS NULL THEN NULL ELSE admin_id END AS voided_by,
      date_voided, void_reason
    FROM input.location_attribute in_loc_att
    INNER JOIN tmp_location tmp_loc
    ON in_loc_att.location_id = tmp_loc.old_id
    INNER JOIN tmp_location_attribute_type tmp_loct
    ON in_loc_att.attribute_type_id = tmp_loct.old_id
    WHERE in_loc_att.value_reference NOT IN (
          SELECT mrs.value_reference
          FROM location_attribute mrs);

  call debugMsg(1, 'location_attribute inserted');

  UPDATE tmp_location_attribute tmp, location_attribute mrs
    SET tmp.new_id = mrs.location_attribute_id
    WHERE tmp.value_reference = mrs.value_reference;

  call debugMsg(1, 'tmp_location_attribute updated');

END $$
DELIMITER ;
