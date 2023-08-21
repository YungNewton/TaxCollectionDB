-- Get tax payments made by individual '1234567890'
CALL GetTaxPaymentByMonth('1234567890', 0);
--Running one at a time.
-- Get tax payments made by individual '1234567892'
CALL GetTaxPaymentByMonth('1234567892', 0);

-- Get tax payments made by company 'A12345678'
CALL GetTaxPaymentByMonth('A12345678', 1);

-- Get tax payments made by company 'B23456789'
CALL GetTaxPaymentByMonth('B23456789', 1);

-- Get total tax paid by companies owned by individual '1234567890'
CALL GetTotalTaxPaidByCompanies('1234567890');

-- Get total tax paid by companies owned by individual '1234567891'
CALL GetTotalTaxPaidByCompanies('1234567891');

-- Get total tax paid by companies owned by individual '1234567892'
CALL GetTotalTaxPaidByCompanies('1234567892');

-- Insert a new company with owners
CALL InsertCompanyWithOwners('C34567890', '2022-01-01', 'https://company-c.example.com', 'contact@company-c.example.com', '["1234567890", "1234567891"]');

-- Insert a new company with a single owner
CALL InsertCompanyWithOwners('D45678901', '2022-06-01', 'https://company-d.example.com', 'contact@company-d.example.com', '["1234567892"]');

-- Insert a tax payment by individual '1234567892'
CALL InsertTaxPayment('1234567892', NULL, 1, 150.00, '2023-09-01', 'Real Estate');

-- Insert a tax payment by company 'C34567890'
CALL InsertTaxPayment(NULL, 'C34567890', 1, 350.00, '2023-09-01', 'Corporate Tax');
--


