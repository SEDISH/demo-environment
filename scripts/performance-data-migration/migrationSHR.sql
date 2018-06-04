drop procedure if exists migrationSHR;
DELIMITER $$
CREATE PROCEDURE migrationSHR()
BEGIN

  # preparation
  SET SQL_SAFE_UPDATES = 0;
  SET foreign_key_checks = 0;
  call createTmpTables();

  # migration
  call personAndPatientMigration();
  call visitMigration();
  call encounterMigration();
  call obsMigration();

  # cleaning
  call dropTmpTables();
  SET foreign_key_checks = 1;
  SET SQL_SAFE_UPDATES = 1;

END$$
DELIMITER ;