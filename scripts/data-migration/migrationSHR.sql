drop procedure if exists migrationSHR;
DELIMITER $$
CREATE PROCEDURE migrationSHR()
BEGIN

  # preparation
  SET SQL_SAFE_UPDATES = 0;
  call createTmpTables();

  # migration
  call locationMigration();
  call personAndPatientMigration();
  call visitMigration();
  call encounterMigration();

  SET foreign_key_checks = 0;
  call obsMigration();
  SET foreign_key_checks = 1;

  # missing values
  call ecidGeneration();

  # cleaning
  call dropTmpTables();
  SET SQL_SAFE_UPDATES = 1;

END$$
DELIMITER ;
