DROP PROCEDURE IF EXISTS mergePerson;
DELIMITER $$
CREATE PROCEDURE mergePerson()
BEGIN
  DECLARE admin_id INTEGER DEFAULT 1;

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
        AND pad.date_changed < in_pad.date_changed
        AND pad.person_id = tmp.new_id
        AND in_pad.person_id = tmp.old_id;

  call debugMsg(1, 'person_address updated by merge');

  UPDATE person_attribute pat, input.person_attribute in_pat, tmp_person_to_merge tmp
    SET pat.`value` = in_pat.`value`,
      pat.person_attribute_type_id = in_pat.person_attribute_type_id,
      pat.creator = CASE WHEN pat.creator  IS NULL THEN NULL ELSE admin_id END,
      pat.date_created = in_pat.date_created,
      pat.date_changed = in_pat.date_changed,
      pat.changed_by = CASE WHEN pat.changed_by  IS NULL THEN NULL ELSE admin_id END,
      pat.uuid  = in_pat.uuid
  WHERE pat.voided = 0
        AND in_pat.voided = 0
        AND pat.date_changed < in_pat.date_changed
        AND pat.person_id = tmp.new_id
        AND in_pat.person_id = tmp.old_id;

  call debugMsg(1, 'person_attribute updated by merge');

END $$
DELIMITER ;
