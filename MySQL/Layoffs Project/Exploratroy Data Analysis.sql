-- EXPLORATROY DATA ANALYSIS

SELECT *
FROM layoffs_cleaned;

-- date range
SELECT MIN(`date`), MAX(`date`)
FROM layoffs_cleaned;

-- which location has the most total laid off
SELECT country, location, SUM(total_laid_off) AS total_off
FROM layoffs_cleaned
GROUP BY country, location
ORDER BY total_off DESC;

-- WHAT IS THE AVERAGE PERCENTAGE FOR EACH INDUSTRY
SELECT industry, 
	ROUND(AVG(percentage_laid_off), 4) AS avg_percentage, 
	ROUND(AVG(total_laid_off), 2) AS avg_total_off, 
    ROUND((AVG(total_laid_off)/AVG(percentage_laid_off)), 0) AS total_num
FROM layoffs_cleaned
WHERE industry IS NOT NULL 
GROUP BY industry
ORDER BY avg_percentage;


-- ROLLING TOTAL OF EACH MONTH
WITH CTE_total_off AS
(
SELECT SUBSTRING(`date`, 1, 7) AS `month`, SUM(total_laid_off) AS total_off
FROM layoffs_cleaned
GROUP BY `month`
HAVING `month` IS NOT NULL
ORDER BY `month`
)
SELECT *, SUM(total_off) OVER( ORDER BY `month`) AS rolling_total
FROM CTE_total_off;

-- TOP FIVE COMPANIES WITH THE LARGEST LAYOFFS EACH YEAR
WITH CTE_total_off_by_year AS
(
	SELECT company, YEAR(`date`) AS `year`, SUM(total_laid_off) AS total_off
	FROM layoffs_cleaned    
	GROUP BY `year`, company
    HAVING `year` IS NOT NULL AND total_off IS NOT NULL
),
CTE_company_rank AS
(
	SELECT company, `year`, total_off, DENSE_RANK() OVER(PARTITION BY `year` ORDER BY total_off DESC) as company_rank
	FROM CTE_total_off_by_year
)
SELECT *
FROM CTE_company_rank
WHERE company_rank <= 5;

