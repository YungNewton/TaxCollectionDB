-- Get tax payments made by individual '1234567892'
CALL GetTaxPaymentByMonth('1234567892', 0);

-- Get tax payments made by individual with a non-existent DocumentNumber '1234567899'
CALL GetTaxPaymentByMonth('1234567899', 0);

-- Get tax payments made by company with a non-existent CUIT 'C12345678'
CALL GetTaxPaymentByMonth('C12345678', 1);
