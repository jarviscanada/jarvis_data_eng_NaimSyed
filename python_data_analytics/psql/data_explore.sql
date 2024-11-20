-- Show table schema

\d+ retail;

-- Show first 10 rows

SELECT * 
FROM retail LIMIT 10;

--Check # of records

SELECT COUNT(*)
FROM retail
LIMIT 10;

--Number of clients (unique client IDS)

SELECT COUNT(DISTINCT client_id)
FROM retail;

-- Show Invoice Date Range

SELECT MAX(invoice_date), MIN(invoice_date) 
FROM retail;


-- Show number of SKU/merchants (unique stock codes)

SELECT COUNT(DISTINCT stock_code)
FROM retail;

-- Calculate average invoice amount excluding invoices with a negative amount (ommit cancelled orders)

SELECT AVG(invoice_total)
FROM (
	SELECT SUM(quantity*unit_price) as invoice_total
	FROM retail
	WHERE (quantity*unit_price) > 0
	GROUP BY invoice_no
) as invoice_totals;

-- Calculate total revenue

SELECT SUM(quantity*unit_price)
FROM retail;

-- Claculate total revenue by YYYYMM

SELECT TO_CHAR(invoice_date, 'YYYYMM') as YYYYMM, SUM(quantity*unit_price)
FROM retail
GROUP BY YYYYMM
ORDER BY YYYYMM ASC;


