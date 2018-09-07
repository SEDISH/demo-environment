DROP PROCEDURE IF EXISTS userMigration;
DELIMITER $$
CREATE PROCEDURE userMigration()
BEGIN

  INSERT INTO tmp_user_to_merge (new_id, old_id, uuid)
    SELECT u.user_id, in_u.user_id, in_u.uuid
    FROM input.users in_u, users u
    WHERE in_u.username IS NOT NULL
      AND in_u.username = u.username;

  call debugMsg(1, 'tmp_user_to_merge inserted');

  INSERT INTO tmp_user (old_id, uuid)
    SELECT in_u.user_id, in_u.uuid
      FROM input.users in_u
      WHERE  in_u.username IS NOT NULL
      AND in_u.user_id NOT IN (SELECT old_id FROM tmp_user_to_merge);

  call debugMsg(1, 'tmp_user inserted');

  INSERT INTO users (system_id, username, creator, date_created, changed_by,
    date_changed, person_id, retired, retired_by, date_retired, retire_reason, uuid)
    SELECT system_id, username, creator, date_created, changed_by,
      date_changed, person_id, retired, retired_by, date_retired, retire_reason, in_u.uuid
    FROM input.users in_u
    INNER JOIN tmp_user tmp
    ON in_u.user_id = tmp.old_id;

  call debugMsg(1, 'users inserted');

  UPDATE tmp_user tmp, users u
    SET tmp.new_id = u.user_id
    WHERE tmp.uuid = u.uuid;

  call debugMsg(1, 'tmp_user updated');

  call mergeUser();

  INSERT INTO tmp_user (new_id, old_id, uuid, is_new, merged)
    SELECT new_id, old_id, uuid, 0, merged
      FROM tmp_user_to_merge;

  call debugMsg(1, 'tmp_user updated after merge');

END $$
DELIMITER ;
