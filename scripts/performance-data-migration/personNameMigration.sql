DROP PROCEDURE IF EXISTS personNameMigration;
DELIMITER $$
CREATE PROCEDURE personNameMigration()
BEGIN
  DECLARE admin_id INTEGER DEFAULT 1;

  INSERT INTO tmp_person_name (old_id, uuid)
    SELECT person_name_id, uuid
    FROM input.person_name;

  call debugMsg(1, 'tmp_person_name inserted');

  INSERT INTO person_name (person_id, preferred, prefix, given_name, middle_name,
                           family_name_prefix, family_name, family_name2, family_name_suffix,
                           degree, creator, date_created, voided, voided_by, date_voided,
                           void_reason, changed_by, date_changed, uuid)
    SELECT person.new_id, preferred, prefix, given_name, middle_name, family_name_prefix,
      family_name, family_name2, family_name_suffix, degree,
      CASE WHEN creator IS NULL THEN NULL ELSE admin_id END AS creator,
      date_created, voided,
      CASE WHEN voided_by IS NULL THEN NULL ELSE admin_id END AS voided_by,
      date_voided, void_reason,
      CASE WHEN changed_by IS NULL THEN NULL ELSE admin_id END AS changed_by,
      date_changed, uuid
    FROM input.person_name AS pn
    INNER JOIN tmp_person person
    ON pn.person_id = tmp_person.old_id;

  call debugMsg(1, 'person_name inserted');

  UPDATE tmp_person_name tmp, person_name per
    SET tmp.new_id = per.person_name_id
    WHERE tmp.uuid = per.uuid;

  call debugMsg(1, 'tmp_person_name updated');

END $$
DELIMITER ;
