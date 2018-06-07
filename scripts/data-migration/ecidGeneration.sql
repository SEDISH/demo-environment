DROP PROCEDURE IF EXISTS ecidGeneration;
DELIMITER $$
CREATE PROCEDURE ecidGeneration()
BEGIN
  DECLARE ecidIdentifierTypeId INTEGER DEFAULT (
    SELECT patient_identifier_type_id FROM patient_identifier_type WHERE uuid = 'f54ed6b9-f5b9-4fd5-a588-8f7561a78401');
  DECLARE isantePlusIdType INTEGER DEFAULT (
    SELECT patient_identifier_type_id FROM patient_identifier_type WHERE uuid = '05a29f94-c0ed-11e2-94be-8c13b969e334');
  DECLARE preferred INTEGER DEFAULT 0;
  DECLARE adminId INTEGER DEFAULT 1;
  DECLARE voided INTEGER DEFAULT 0;

  INSERT INTO patient_identifier (patient_id, identifier, identifier_type,
      preferred, location_id, creator, date_created, date_changed, changed_by, voided, voided_by,
      date_voided, void_reason, uuid)
  SELECT p.patient_id, UUID(), ecidIdentifierTypeId, preferred, pi.location_id, adminId, NOW(), NULL, NULL,
      voided, NULL, NULL, NULL, UUID()
  FROM patient p, patient_identifier pi
  WHERE p.patient_id = pi.patient_id
      AND p.patient_id NOT IN (SELECT patient_id FROM patient_identifier pi
          WHERE pi.identifier_type = ecidIdentifierTypeId)
      AND pi.identifier_type = isantePlusIdType;

  call debugMsg(1, 'ECID identifiers generated and inserted');

END $$
DELIMITER ;
