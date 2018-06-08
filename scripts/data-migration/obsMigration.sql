drop procedure if exists obsMigration;
DELIMITER $$
CREATE PROCEDURE obsMigration()
BEGIN
  DECLARE admin_id INTEGER DEFAULT 1;
  # obs migration
  INSERT INTO tmp_obs (old_id, uuid)
    SELECT obs_id, uuid
    FROM input.obs;

  call debugMsg(1, 'tmp_obs inserted');

  INSERT INTO obs (person_id, concept_id, encounter_id, order_id, obs_datetime,
                         location_id, obs_group_id, accession_number, value_group_id, value_coded,
                         value_coded_name_id, value_drug, value_datetime, value_numeric,
                         value_modifier, value_text, value_complex, comments, creator, date_created,
                         voided, voided_by, date_voided, void_reason, uuid, previous_version,
                         form_namespace_and_path)
    SELECT tmp_p.new_id, in_obs.concept_id, tmp_en.new_id, in_obs.order_id, in_obs.obs_datetime,
      tmp_loc.new_id, in_obs.obs_group_id, in_obs.accession_number, value_group_id,
      in_obs.value_coded, value_coded_name_id, in_obs.value_drug, in_obs.value_datetime,
      in_obs.value_numeric, in_obs.value_modifier, in_obs.value_text, in_obs.value_complex,
      in_obs.comments,
      CASE WHEN creator IS NULL THEN NULL ELSE admin_id END AS creator,
      in_obs.date_created, in_obs.voided,
	  CASE WHEN voided_by IS NULL THEN NULL ELSE admin_id END AS voided_by,
      in_obs.date_voided, in_obs.void_reason, in_obs.uuid, in_obs.previous_version,
      in_obs.form_namespace_and_path
    FROM input.obs in_obs
    INNER JOIN tmp_person tmp_p
    ON in_obs.person_id = tmp_p.old_id
    INNER JOIN tmp_encounter tmp_en
    ON in_obs.encounter_id = tmp_en.old_id
    LEFT JOIN tmp_location tmp_loc  # left join - entity should be inserted even if location id is Null
    ON in_obs.location_id = tmp_loc.old_id;

  call debugMsg(1, 'obs inserted');

  UPDATE tmp_obs tmp, obs mrs
    SET tmp.new_id = mrs.obs_id
    WHERE tmp.uuid = mrs.uuid;

  call debugMsg(1, 'tmp_obs updated');

  UPDATE obs mrs, tmp_obs tmp
    SET mrs.obs_group_id = tmp.new_id
    WHERE mrs.obs_group_id = tmp.old_id;

  call debugMsg(1, 'obs_group_id in obs table updated');

  UPDATE obs mrs, tmp_obs tmp
    SET mrs.previous_version = tmp.new_id
    WHERE mrs.previous_version = tmp.old_id;

  call debugMsg(1, 'previous_version in obs table updated');

END $$
DELIMITER ;
