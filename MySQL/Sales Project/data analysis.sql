-- DATA CLEAN

SELECT * FROM sales_report_2023;

DROP TABLE IF EXISTS rix_sales_2023_staging;

CREATE TABLE sales_report_2023_staging
SELECT * FROM sales_report_2023;

-- STANDERDIZE COLUMN NAME
ALTER TABLE sales_report_2023_staging
RENAME COLUMN `payment #` TO payment_id,
RENAME COLUMN `Customer Name` TO customer_name,
RENAME COLUMN `Invoice #` TO invoice_id;

SELECT * FROM sales_report_2023_staging;

-- format date
UPDATE sales_report_2023_staging
SET `date` = str_to_date(`date`, '%M %d, %Y');

-- update date to datetime
ALTER TABLE sales_report_2023_staging
MODIFY `date` DATE;

-- update amount to float
SELECT CONVERT(REPLACE(SUBSTRING(AMOUNT,2),',',''), DECIMAL(8,2))
FROM sales_report_2023_staging;

UPDATE sales_report_2023_staging
SET Amount = CONVERT(REPLACE(SUBSTRING(AMOUNT,2),',',''), DECIMAL(8,2));

ALTER TABLE sales_report_2023_staging
MODIFY AMOUNT DECIMAL(8,2);

-- SALES PER MONTH
SELECT MONTH(`date`) AS `month`, SUM(Amount) AS total_sale
FROM sales_report_2023_staging
GROUP BY `month`
ORDER BY `month`;

WITH cte_rolling_total AS
(
	SELECT MONTH(`date`) AS `month`, SUM(Amount) AS total_sale
	FROM sales_report_2023_staging
	GROUP BY `month`
	ORDER BY `month`
)
SELECT *, SUM(total_sale) OVER(ORDER BY `month`) AS rolling_total
FROM cte_rolling_total;

-- SALES BY CUSTOMER
WITH cte_customer_sales AS
(
	SELECT customer_name, SUM(amount) as total_sale
	FROM sales_report_2023_staging
	GROUP BY customer_name
	ORDER BY total_sale DESC
)
SELECT *, RANK() OVER(ORDER BY total_sale DESC) AS `rank`
FROM cte_customer_sales;

-- TOP 5 BUYERS EACH MONTH
WITH cte_customer_monthly_sales AS
(
	SELECT MONTH(`date`) AS `month`, customer_name, SUM(amount) as total_sale
	FROM sales_report_2023_staging
	GROUP BY `month`, customer_name
	ORDER BY total_sale DESC
),
cte_rank AS
(
	SELECT *, DENSE_RANK() OVER(PARTITION BY `month` ORDER BY total_sale DESC) as `rank`
	FROM cte_customer_monthly_sales
)
SELECT *
FROM cte_rank
WHERE `rank` <= 5;