DROP PROCEDURE IF EXISTS updateCreatorAndPersonId;
DELIMITER $$
CREATE PROCEDURE updateCreatorAndPersonId()
BEGIN

UPDATE users u, tmp_user tmp_u, tmp_person tmp_p
  SET u.person_id = tmp_p.new_id
WHERE u.user_id = tmp_u.new_id
  AND (tmp_u.is_new = 1 OR tmp_u.merged = 1)
  AND u.person_id = tmp_p.old_id;

call debugMsg(1, 'person_id in users table updated');

UPDATE users u, tmp_user tmp_u
  SET u.creator = tmp_u.new_id
WHERE u.creator = tmp_u.old_id
  AND u.user_id IN (SELECT tmp_u.new_id
    FROM tmp_user tmp_u
    WHERE tmp_u.is_new = 1 OR tmp_u.merged = 1);

call debugMsg(1, 'creator in users table updated');

UPDATE users u, tmp_user tmp_u
  SET u.changed_by = tmp_u.new_id
WHERE u.changed_by IS NOT NULL
  AND u.changed_by = tmp_u.old_id
  AND u.user_id IN (SELECT tmp_u.new_id
    FROM tmp_user tmp_u
    WHERE tmp_u.is_new = 1 OR tmp_u.merged = 1);


call debugMsg(1, 'changed_by in users table updated');

UPDATE users u, tmp_user tmp_u
  SET u.retired_by = tmp_u.new_id
WHERE u.retired_by IS NOT NULL
  AND u.retired_by = tmp_u.old_id
  AND u.user_id IN (SELECT tmp_u.new_id
    FROM tmp_user tmp_u
    WHERE tmp_u.is_new = 1 OR tmp_u.merged = 1);

call debugMsg(1, 'retired_by in users table updated');

UPDATE patient p, tmp_user tmp_u, tmp_person tmp_p
  SET p.creator = tmp_u.new_id
WHERE p.patient_id = tmp_p.new_id
  AND p.creator = tmp_u.old_id;

call debugMsg(1, 'creator in patient table updated');

END $$
DELIMITER ;
