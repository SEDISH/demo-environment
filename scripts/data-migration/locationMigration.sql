DROP PROCEDURE IF EXISTS locationMigration;
DELIMITER $$
CREATE PROCEDURE locationMigration()
BEGIN
  DECLARE admin_id INTEGER DEFAULT 1;

  INSERT INTO tmp_location (old_id, `name`)
    SELECT location_id, `name`
    FROM input.location;

  call debugMsg(1, 'tmp_location inserted');

  INSERT INTO location (`name`, description, address1, address2, city_village, state_province, postal_code,
      country, latitude, longitude, creator, date_created, county_district, address3, address4, address5,
      address6, retired, retired_by, date_retired, retire_reason, parent_location, uuid, changed_by, date_changed, address7,
      address8, address9, address10, address11, address12, address13, address14, address15)
    SELECT `name`, description, address1, address2, city_village, state_province, postal_code,
        country, latitude, longitude,
        CASE WHEN creator IS NULL THEN NULL ELSE admin_id END AS creator,
        date_created, county_district, address3, address4, address5,
        address6, retired,
        CASE WHEN retired_by IS NULL THEN NULL ELSE admin_id END AS retired_by,
        date_retired, retire_reason, parent_location, uuid,
        CASE WHEN changed_by IS NULL THEN NULL ELSE admin_id END AS changed_by,
        date_changed, address7, address8, address9, address10, address11, address12, address13, address14, address15
    FROM input.location in_loc
    WHERE in_loc.`name` NOT IN (SELECT mrs_loc.`name`
                                FROM location mrs_loc);

  call debugMsg(1, 'location inserted');

  UPDATE tmp_location tmp, location mrs
    SET tmp.new_id = mrs.location_id
    WHERE tmp.`name` = mrs.`name`;

  call debugMsg(1, 'tmp_location updated');

END $$
DELIMITER ;
