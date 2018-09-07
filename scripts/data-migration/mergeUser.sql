DROP PROCEDURE IF EXISTS mergeUser;
DELIMITER $$
CREATE PROCEDURE mergeUser()
BEGIN

  UPDATE users u, input.users in_u, tmp_user_to_merge tmp
    SET
    u.system_id = in_u.system_id,
    u.username = in_u.username,
    u.creator = in_u.creator,
    u.date_created = in_u.date_created,
    u.changed_by = in_u.changed_by,
    u.date_changed = in_u.date_changed,
    u.person_id = in_u.person_id,
    u.retired = in_u.retired,
    u.retired_by = in_u.retired_by,
    u.date_retired = in_u.date_retired,
    u.retire_reason = in_u.retire_reason,
    u.uuid = in_u.uuid,
    tmp.merged = 1
  WHERE u.retired = 0
    AND u.date_created < in_u.date_created
    AND u.user_id = tmp.new_id
    AND in_u.user_id = tmp.old_id;

  call debugMsg(1, 'users updated by merge');

END $$
DELIMITER ;
