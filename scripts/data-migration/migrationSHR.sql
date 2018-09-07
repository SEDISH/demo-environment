drop procedure if exists migrationSHR;
DELIMITER $$
CREATE PROCEDURE migrationSHR()
BEGIN

  # preparation
  SET SQL_SAFE_UPDATES = 0;
  # cleaning and creating temp tables
  call dropTmpTables();
  call createTmpTables();

  # migration
  call locationMigration();
  SET foreign_key_checks = 0;
  call userMigration();
  call personAndPatientMigration();
  SET foreign_key_checks = 1;
  call updateCreatorAndPersonId();
  call visitMigration();
  call encounterMigration();
  call providerMigration();

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
