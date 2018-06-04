DROP PROCEDURE IF EXISTS personAddressMigration;
DELIMITER $$
CREATE PROCEDURE personAddressMigration()
BEGIN
  DECLARE admin_id INTEGER DEFAULT 1;

  INSERT INTO tmp_person_address (old_id, uuid)
    SELECT person_address_id, uuid
    FROM input.person_address;

  call debugMsg(1, 'tmp_person_address inserted');

  INSERT INTO person_address (person_id, preferred, address1, address2,
    city_village, state_province, postal_code, country, latitude, longitude,
    start_date, end_date, creator, date_created, voided, voided_by, date_voided,
    void_reason, county_district, address3, address4, address5, address6, date_changed, changed_by,
    uuid)
    SELECT person.new_id, preferred, address1, address2, city_village, state_province, postal_code,
      country, latitude, longitude, start_date, end_date,
      CASE WHEN creator IS NULL THEN NULL ELSE admin_id END AS creator,
      date_created, voided,
      CASE WHEN voided_by IS NULL THEN NULL ELSE admin_id END AS voided_by,
      date_voided, void_reason, county_district, address3, address4, address5, address6,
      date_changed,
      CASE WHEN changed_by IS NULL THEN NULL ELSE admin_id END AS changed_by,
      pa.uuid
    FROM input.person_address AS pa
    INNER JOIN tmp_person AS person
    ON pa.person_id = person.old_id;

  call debugMsg(1, 'person_address inserted');

  UPDATE tmp_person_address tmp, person_address per
    SET tmp.new_id = per.person_address_id
    WHERE tmp.uuid = per.uuid;

  call debugMsg(1, 'tmp_person_address updated');

END $$
DELIMITER ;
