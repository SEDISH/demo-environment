DELIMITER $$ 
DROP PROCEDURE IF EXISTS debugMsg$$
CREATE PROCEDURE debugMsg(enabled INTEGER, msg VARCHAR(255))
BEGIN
  IF enabled THEN BEGIN
    select concat("** ", msg) AS '** DEBUG:';
  END; END IF;
END$$
DELIMITER ;
