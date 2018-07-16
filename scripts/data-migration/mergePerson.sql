DROP PROCEDURE IF EXISTS mergePerson;
DELIMITER $$
CREATE PROCEDURE mergePerson()
BEGIN
  DECLARE admin_id INTEGER DEFAULT 1;

  UPDATE person per, input.person in_per, tmp_person_to_merge tmp
    SET per.gender = in_per.gender,
      per.birthdate = in_per.birthdate,
      per.birthdate_estimated = in_per.birthdate_estimated,
      per.birthtime = in_per.birthtime,
      per.dead = in_per.dead,
      per.death_date = in_per.death_date,
      per.deathdate_estimated = in_per.deathdate_estimated,
      per.cause_of_death = in_per.cause_of_death,
      per.creator = CASE WHEN per.creator  IS NULL THEN NULL ELSE admin_id END,
      per.date_created = in_per.date_created,
      per.date_changed = in_per.date_changed,
      per.changed_by = CASE WHEN per.changed_by  IS NULL THEN NULL ELSE admin_id END,
      per.uuid  = in_per.uuid
  WHERE per.voided = 0
        AND in_per.voided = 0
        AND per.date_created < in_per.date_created
        AND per.person_id = tmp.new_id
        AND in_per.person_id = tmp.old_id;

  call debugMsg(1, 'person updated by merge');

  UPDATE patient pat, input.patient in_pat, tmp_person_to_merge tmp
    SET pat.creator = CASE WHEN pat.creator  IS NULL THEN NULL ELSE admin_id END,
      pat.date_created = in_pat.date_created,
      pat.date_changed = in_pat.date_changed,
      pat.changed_by = CASE WHEN pat.changed_by  IS NULL THEN NULL ELSE admin_id END
  WHERE pat.voided = 0
        AND in_pat.voided = 0
        AND pat.date_created < in_pat.date_created
        AND pat.patient_id = tmp.new_id
        AND in_pat.patient_id = tmp.old_id;

  call debugMsg(1, 'person updated by merge');

  UPDATE person_address pad, input.person_address in_pad, tmp_person_to_merge tmp
    SET pad.preferred = in_pad.preferred,
      pad.address1 = in_pad.address1,
      pad.address2 = in_pad.address2,
      pad.city_village = in_pad.city_village,
      pad.state_province = in_pad.state_province,
      pad.postal_code = in_pad.postal_code,
      pad.country = in_pad.country,
      pad.latitude = in_pad.latitude,
      pad.longitude = in_pad.longitude,
      pad.start_date = in_pad.start_date,
      pad.end_date = in_pad.end_date,
      pad.creator = CASE WHEN pad.creator  IS NULL THEN NULL ELSE admin_id END,
      pad.date_created = in_pad.date_created,
      pad.county_district = in_pad.county_district,
      pad.address3 = in_pad.address3,
      pad.address4 = in_pad.address4,
      pad.address5 = in_pad.address5,
      pad.address6 = in_pad.address6,
      pad.date_changed = in_pad.date_changed,
      pad.changed_by = CASE WHEN pad.changed_by  IS NULL THEN NULL ELSE admin_id END,
      pad.uuid  = in_pad.uuid
  WHERE pad.voided = 0
        AND in_pad.voided = 0
        AND pad.date_created < in_pad.date_created
        AND pad.person_id = tmp.new_id
        AND in_pad.person_id = tmp.old_id;

  call debugMsg(1, 'person_address updated by merge');

  UPDATE person_attribute pat, input.person_attribute in_pat, tmp_person_to_merge tmp
    SET pat.`value` = in_pat.`value`,
      pat.creator = CASE WHEN pat.creator  IS NULL THEN NULL ELSE admin_id END,
      pat.date_created = in_pat.date_created,
      pat.date_changed = in_pat.date_changed,
      pat.changed_by = CASE WHEN pat.changed_by  IS NULL THEN NULL ELSE admin_id END,
      pat.uuid  = in_pat.uuid
  WHERE pat.voided = 0
        AND in_pat.voided = 0
        AND pat.date_created < in_pat.date_created
        AND pat.person_id = tmp.new_id
        AND in_pat.person_id = tmp.old_id
        AND pat.person_attribute_type_id = in_pat.person_attribute_type_id;

  call debugMsg(1, 'person_attribute updated by merge');

  UPDATE person_name pn, input.person_name in_pn, tmp_person_to_merge tmp
    SET pn.preferred = in_pn.preferred,
      pn.prefix = in_pn.prefix,
      pn.given_name = in_pn.given_name,
      pn.middle_name = in_pn.middle_name,
      pn.family_name_prefix = in_pn.family_name_prefix,
      pn.family_name = in_pn.family_name,
      pn.family_name2 = in_pn.family_name2,
      pn.family_name_suffix = in_pn.family_name_suffix,
      pn.degree = in_pn.degree,
      pn.creator = CASE WHEN pn.creator  IS NULL THEN NULL ELSE admin_id END,
      pn.date_created = in_pn.date_created,
      pn.date_changed = in_pn.date_changed,
      pn.changed_by = CASE WHEN pn.changed_by  IS NULL THEN NULL ELSE admin_id END,
      pn.uuid  = in_pn.uuid
  WHERE pn.voided = 0
        AND in_pn.voided = 0
        AND pn.date_created < in_pn.date_created
        AND pn.person_id = tmp.new_id
        AND in_pn.person_id = tmp.old_id;

  call debugMsg(1, 'person_name updated by merge');

END $$
DELIMITER ;
