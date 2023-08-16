-- Creating table for individuals with their basic details
CREATE TABLE Individuals (
    DocumentNumber VARCHAR(20) PRIMARY KEY, -- Unique identifier for each individual
    FullName VARCHAR(100), -- Full name of the individual
    DateOfBirth DATE, -- Date of birth of the individual
    HomeAddress VARCHAR(255), -- Home address of the individual
    Email VARCHAR(100) -- Email address of the individual
);

-- Creating table for contact numbers of individuals
CREATE TABLE ContactNumbers (
    ContactID INT PRIMARY KEY AUTO_INCREMENT, -- Unique identifier for each contact number
    IndividualID VARCHAR(20), -- Identifier for the individual associated with the contact number
    ContactType VARCHAR(50), -- Type of contact number (e.g., Landline, Mobile, Fax)
    ContactValue VARCHAR(15), -- The actual contact number
    FOREIGN KEY (IndividualID) REFERENCES Individuals (DocumentNumber) -- Foreign key reference to the Individuals table
);

-- Creating table for companies with their basic details
CREATE TABLE Companies (
    CUIT VARCHAR(20) PRIMARY KEY, -- Unique identifier for each company
    CommencementDate DATE, -- Date of commencement of the company
    Website VARCHAR(255), -- Website of the company
    Email VARCHAR(100) -- Email address of the company
);

-- Creating table for company contact information
CREATE TABLE CompanyContacts (
    ContactID INT AUTO_INCREMENT PRIMARY KEY, -- Unique identifier for each contact entry
    CUIT VARCHAR(20), -- CUIT number of the company
    ContactType VARCHAR(15), -- Type of contact (e.g., Landline, Mobile, Fax, etc.)
    FOREIGN KEY (CUIT) REFERENCES Companies(CUIT) ON DELETE CASCADE -- Reference to the Companies table
);

-- Creating table for ownership details
CREATE TABLE Ownership (
    OwnershipID INT AUTO_INCREMENT PRIMARY KEY, -- Unique identifier for each ownership entry
    IndividualID VARCHAR(20), -- Document number of the individual owner
    CompanyID VARCHAR(20), -- CUIT number of the owned company
    FOREIGN KEY (IndividualID) REFERENCES Individuals(DocumentNumber) ON DELETE CASCADE, -- Reference to the Individuals table
    FOREIGN KEY (CompanyID) REFERENCES Companies(CUIT) ON DELETE CASCADE -- Reference to the Companies table
);

-- Ensure that every company has at least one owner when it is created.
DELIMITER //
CREATE TRIGGER tr_After_Insert_Company
AFTER INSERT ON Companies
FOR EACH ROW
BEGIN
  -- You can specify a default owner here or handle it in your application logic.
  -- Here we're using a placeholder owner '1234567890'.
  INSERT INTO Ownership (IndividualID, CompanyID) VALUES ('1234567890', NEW.CUIT);
END;
//
DELIMITER ;

-- Creating table for agency offices with their basic details
CREATE TABLE Agency (
    OfficeNumber INT PRIMARY KEY, -- Unique identifier for each agency office
    Address VARCHAR(255), -- Address of the agency office
    Telephone VARCHAR(15), -- Contact number of the agency office
    PersonInCharge VARCHAR(50), -- Person in charge of the agency office
    NumberOfEmployees INT -- Number of employees in the agency office
);
-- Creating table for tax payments with details and relationships to Individuals and Agencies
CREATE TABLE TaxPayment (
    PaymentID INT PRIMARY KEY AUTO_INCREMENT, -- Unique payment ID for each payment
    IndividualID VARCHAR(20), -- Document number of the individual taxpayer
    CompanyID VARCHAR(20), -- CUIT number of the company taxpayer
    AgencyID INT, -- Office number of the agency where payment was made
    Amount DECIMAL(10, 2), -- Amount of the tax payment
    PaymentDate DATE, -- Date of the tax payment
    TaxType VARCHAR(50), -- Type of the tax payment (e.g., Real Estate, Automotive Patent, etc.)
    UNIQUE (IndividualID, AgencyID, PaymentDate, TaxType), -- Constraint to ensure no duplicate payment by individuals
    UNIQUE (CompanyID, AgencyID, PaymentDate, TaxType), -- Constraint to ensure no duplicate payment by companies
    FOREIGN KEY (IndividualID) REFERENCES Individuals(DocumentNumber), -- Foreign key reference to Individuals table
    FOREIGN KEY (CompanyID) REFERENCES Companies(CUIT), -- Foreign key reference to Companies table
    FOREIGN KEY (AgencyID) REFERENCES Agency(OfficeNumber) -- Foreign key reference to Agency table
);