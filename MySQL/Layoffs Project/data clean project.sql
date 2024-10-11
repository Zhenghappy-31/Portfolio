-- data clean

SELECT *
FROM layoffs;

-- remove duplicate data

DROP TABLE IF EXISTS layoffs_staging;

CREATE TABLE layoffs_staging
LIKE layoffs;

INSERT INTO layoffs_staging
SELECT * 
FROM layoffs;

SELECT *, 
	ROW_NUMBER() OVER
		(
			partition by company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions
		) AS row_num
FROM layoffs_staging
ORDER BY row_num DESC;


WITH duplicate_cte AS
(
	SELECT *, 
	ROW_NUMBER() OVER
		(
			partition by company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions
		) AS row_num
	FROM layoffs_staging
)
SELECT *
FROM duplicate_cte
WHERE row_num > 1;

DROP TABLE IF EXISTS layoffs_staging_dupicate_removed;

CREATE TABLE `layoffs_staging_dupicate_removed` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  `row_num` int
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;



INSERT INTO layoffs_staging_dupicate_removed
SELECT *, ROW_NUMBER() OVER
	(
			partition by company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions
	) AS row_num
FROM layoffs_staging;

SELECT * 
FROM layoffs_staging_dupicate_removed
ORDER BY row_num DESC;

DELETE FROM layoffs_staging_dupicate_removed
WHERE row_num > 1;

SELECT * 
FROM layoffs_staging_dupicate_removed;


-- standerdizing data

DROP TABLE IF EXISTS layoffs_staging_standerdize;

CREATE TABLE layoffs_staging_standerdize
LIKE layoffs_staging_dupicate_removed;

INSERT INTO layoffs_staging_standerdize
SELECT *
FROM layoffs_staging_dupicate_removed;

SELECT *
FROM layoffs_staging_standerdize;

SELECT company, TRIM(company)
FROM layoffs_staging_standerdize;

UPDATE layoffs_staging_standerdize
SET company = TRIM(company);

SELECT DISTINCT industry
FROM layoffs_staging_standerdize
ORDER BY industry;

SELECT DISTINCT industry
FROM layoffs_staging_standerdize
WHERE industry LIKE '%Crypto%';

UPDATE layoffs_staging_standerdize
SET industry = 'Crypto'
WHERE industry LIKE '%Crypto%';

SELECT DISTINCT country
FROM layoffs_staging_standerdize
ORDER BY 1;

SELECT country
FROM layoffs_staging_standerdize
WHERE country LIKE "United States%";

UPDATE layoffs_staging_standerdize
SET country = TRIM(TRAILING '.' FROM country)
WHERE country LIKE 'United States%';

SELECT `date`,
	STR_TO_DATE(`date`, '%m/%d/%Y')
FROM layoffs_staging_standerdize;

UPDATE layoffs_staging_standerdize
SET `date` = STR_TO_DATE(`date`, '%m/%d/%Y');

ALTER TABLE layoffs_staging_standerdize
MODIFY COLUMN `date` DATE;


-- FIXING NULL OR BLANK VALUES


SELECT L1.industry, L2.industry
FROM layoffs_staging_standerdize as l1
JOIN layoffs_staging_standerdize as l2
	ON l1.company = l2.company AND L1.location = L2.location
WHERE (l1.industry = '' OR l1.industry IS NULL) AND (l2.industry != '' AND l2.industry IS NOT NULL);

UPDATE layoffs_staging_standerdize as l1
JOIN layoffs_staging_standerdize as l2
	ON l1.company = l2.company AND L1.location = L2.location
SET l1.industry = l2.industry
WHERE (L1.industry is null or l1.industry = '') AND (l2.industry is not null AND l2.industry != '');


-- DELETE UNRILIABLE DATA


SELECT *
FROM layoffs_staging_standerdize
WHERE (total_laid_off IS NULL OR total_laid_off = '')AND (percentage_laid_off IS NULL OR percentage_laid_off = '');

DELETE 
FROM layoffs_staging_standerdize
WHERE (total_laid_off IS NULL OR total_laid_off = '') AND (percentage_laid_off IS NULL OR percentage_laid_off = '');

ALTER TABLE layoffs_staging_standerdize
DROP COLUMN row_num;


-- FINAL OUTPUT


DROP TABLE IF EXISTS `layoffs_cleaned`;
CREATE TABLE `layoffs_cleaned` LIKE `layoffs_staging_standerdize`;
INSERT INTO `layoffs_cleaned`
SELECT *
FROM `layoffs_staging_standerdize`;

SELECT *
FROM layoffs_cleaned;

