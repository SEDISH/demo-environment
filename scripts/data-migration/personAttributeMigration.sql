drop procedure if exists personAttributeMigration;
DELIMITER $$
CREATE PROCEDURE personAttributeMigration()
BEGIN
  DECLARE admin_id INTEGER DEFAULT 1;

  INSERT INTO tmp_person_attribute_type (old_id, uuid)
    SELECT person_attribute_type_id, uuid
    FROM input.person_attribute_type;

  INSERT INTO person_attribute_type (`name`, description, `format`, foreign_key, searchable,
                                     creator, date_created, changed_by, date_changed, retired,
                                     retired_by, date_retired, retire_reason, edit_privilege,
                                     sort_weight, uuid)
    SELECT `name`, description, `format`, foreign_key, searchable,
      CASE WHEN creator IS NULL THEN NULL ELSE admin_id END AS creator,
      date_created,
      CASE WHEN changed_by IS NULL THEN NULL ELSE admin_id END AS changed_by,
      date_changed, retired,
      CASE WHEN retired_by IS NULL THEN NULL ELSE admin_id END AS retired_by,
      date_retired, retire_reason, edit_privilege, sort_weight, in_pat.uuid
      FROM input.person_attribute_type in_pat
      WHERE NOT EXISTS (
          SELECT mrs.uuid
          FROM person_attribute_type mrs
          WHERE in_pat.uuid = mrs.uuid);

  UPDATE tmp_person_attribute_type tmp, person_attribute_type mrs
    SET tmp.new_id = mrs.person_attribute_type_id
    WHERE tmp.uuid = mrs.uuid;

  call debugMsg(1, 'tmp_person_attribute_type done');

  INSERT INTO tmp_person_attribute (old_id, uuid)
    SELECT person_attribute_id, uuid
    FROM input.person_attribute;

  call debugMsg(1, 'tmp_person_attribute inserted');

  INSERT INTO person_attribute (person_id, `value`, person_attribute_type_id, creator, date_created,
                                changed_by, date_changed, voided, voided_by, date_voided,
                                void_reason, uuid)
    SELECT tmp_person.new_id, `value`, tmp_pat.new_id,
      CASE WHEN creator IS NULL THEN NULL ELSE admin_id END AS creator,
      date_created,
      CASE WHEN changed_by IS NULL THEN NULL ELSE admin_id END AS changed_by,
      date_changed, voided,
      CASE WHEN voided_by IS NULL THEN NULL ELSE admin_id END AS voided_by,
      date_voided, void_reason, in_pa.uuid
    FROM input.person_attribute in_pa
    INNER JOIN tmp_person
    ON in_pa.person_id = tmp_person.old_id
    INNER JOIN tmp_person_attribute_type tmp_pat
    ON in_pa.person_attribute_type_id = tmp_pat.old_id;

  call debugMsg(1, 'person_attribute inserted');

  UPDATE tmp_person_attribute tmp, person_attribute mrs
    SET tmp.new_id = mrs.person_attribute_id
    WHERE tmp.uuid = mrs.uuid;

  call debugMsg(1, 'tmp_person_attribute updated');

END $$
DELIMITER ;

