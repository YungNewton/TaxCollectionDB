-- QUERY: Tax Payment by Month
-- FUNCTION: Summarizes tax payments by a specified taxpayer by year and month.
-- INPUT: TaxPayerID (parameter to filter results by specific taxpayer), isCompany (boolean parameter indicating whether the taxpayer is a company or not)

-- Drop the existing stored procedure
DROP PROCEDURE IF EXISTS GetTaxPaymentByMonth;
DELIMITER $$

CREATE PROCEDURE GetTaxPaymentByMonth(TaxPayerID VARCHAR(20), isCompany BOOLEAN)
BEGIN
  IF isCompany THEN
    SELECT YEAR(PaymentDate) AS Year, MONTH(PaymentDate) AS Month, SUM(Amount) AS TotalPaid
    FROM TaxPayment
    WHERE CompanyID = TaxPayerID
    GROUP BY YEAR(PaymentDate), MONTH(PaymentDate);
  ELSE
    SELECT YEAR(PaymentDate) AS Year, MONTH(PaymentDate) AS Month, SUM(Amount) AS TotalPaid
    FROM TaxPayment
    WHERE IndividualID = TaxPayerID
    GROUP BY YEAR(PaymentDate), MONTH(PaymentDate);
  END IF;
END $$

DELIMITER ;


DROP PROCEDURE IF EXISTS GetTotalTaxPaidByCompanies;
DELIMITER $$

CREATE PROCEDURE GetTotalTaxPaidByCompanies(IndividualID VARCHAR(20))
BEGIN
  SELECT 
    IndividualID,
    SUM(Amount) AS TotalPaid
  FROM 
    TaxPayment 
  WHERE 
    CompanyID IN (SELECT CompanyID FROM Ownership WHERE IndividualID = IndividualID)
  GROUP BY 
    IndividualID;
END $$

DELIMITER ;

DROP PROCEDURE IF EXISTS InsertCompanyWithOwners;
DELIMITER $$

CREATE PROCEDURE InsertCompanyWithOwners(CUIT VARCHAR(20), CommencementDate DATE, Website VARCHAR(255), Email VARCHAR(100), Owners VARCHAR(255))
BEGIN
  DECLARE OwnerID VARCHAR(20);
  DECLARE owner_cursor CURSOR FOR SELECT DISTINCT TRIM(VALUE) FROM JSON_TABLE(Owners, '$[*]' COLUMNS (VALUE VARCHAR(20) PATH '$')) AS json_tbl;
  
  -- Insert new company
  INSERT INTO Companies(CUIT, CommencementDate, Website, Email)
  VALUES (CUIT, CommencementDate, Website, Email);
  
  -- Insert owners
  OPEN owner_cursor;
  fetch_loop: LOOP
    FETCH owner_cursor INTO OwnerID;
    INSERT INTO Ownership(IndividualID, CompanyID)
    VALUES (OwnerID, CUIT);
  END LOOP fetch_loop;
  
  CLOSE owner_cursor;
END $$

DELIMITER ;

DROP PROCEDURE IF EXISTS InsertTaxPayment;
DELIMITER $$

CREATE PROCEDURE InsertTaxPayment(IndividualID VARCHAR(20), CompanyID VARCHAR(20), AgencyID INT, Amount DECIMAL(10, 2), PaymentDate DATE, TaxType VARCHAR(50))
BEGIN
  DECLARE validPayment INT;
  SET validPayment = 0;
  
  -- Check for duplicate payment by individual
  IF IndividualID IS NOT NULL THEN
    SELECT COUNT(*) INTO validPayment
    FROM TaxPayment
    WHERE IndividualID = IndividualID AND AgencyID = AgencyID AND PaymentDate = PaymentDate AND TaxType = TaxType;
  END IF;

  -- Check for duplicate payment by company
  IF CompanyID IS NOT NULL THEN
    SELECT COUNT(*) INTO validPayment
    FROM TaxPayment
    WHERE CompanyID = CompanyID AND AgencyID = AgencyID AND PaymentDate = PaymentDate AND TaxType = TaxType;
  END IF;
  
  IF validPayment = 0 THEN
    INSERT INTO TaxPayment(IndividualID, CompanyID, AgencyID, Amount, PaymentDate, TaxType)
    VALUES (IndividualID, CompanyID, AgencyID, Amount, PaymentDate, TaxType);
  ELSE
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Duplicate payment entry not allowed.';
  END IF;
END $$

DELIMITER ;
