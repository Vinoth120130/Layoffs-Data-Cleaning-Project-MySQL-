-- Data Cleaning --

USE world_layoffs;
SELECT * FROM layoffs;

-- Remove Duplicates -- 
-- Standardize the Data -- 
-- Fixing Null Values -- 
-- Remove any Extra columns and Rows -- 


CREATE TABLE layoffs_copy
LIKE layoffs;

INSERT INTO layoffs_copy
SELECT * FROM layoffs;

SELECT * FROM layoffs_copy;

-- Removing Duplicates --

SELECT *, ROW_NUMBER() OVER(PARTITION BY company,location,industry,total_laid_off,
							percentage_laid_off,`date`,stage,country,funds_raised_millions) as Row_num
FROM layoffs_copy;

With duplicated_cte as
(SELECT *, ROW_NUMBER() OVER(PARTITION BY company,location,industry,total_laid_off,
							percentage_laid_off,`date`,stage,country,funds_raised_millions) as row_num
FROM layoffs_copy
)
SELECT * FROM duplicated_cte
WHERE row_num >1;
		
CREATE TABLE `layoffs_copy1` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  `row_number` int
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

INSERT INTO layoffs_copy1
SELECT *, ROW_NUMBER() OVER(PARTITION BY company,location,industry,total_laid_off,
							percentage_laid_off,`date`,stage,country,funds_raised_millions) as row_num
FROM layoffs_copy;

SELECT * FROM layoffs_copy1; -- Duplicated the datasets and added new columns named row_number from layoffs_copy --

SELECT * FROM layoffs_copy1
WHERE `row_number`>1;

 -- Delected the duplicated rows --
DELETE
FROM layoffs_copy1 
WHERE `row_number`>1; 

SELECT * FROM layoffs_copy1
WHERE `row_number`>1; -- Cross check the duplicated rows --

-- Standerding the Data --
SELECT * FROM layoffs_copy1;

SELECT TRIM(company) FROM layoffs_copy1;
UPDATE layoffs_copy1
SET company = TRIM(company);

SELECT DISTINCT(industry) FROM layoffs_copy1
ORDER BY industry asc; -- There is an null, blank space and repited 'crypto' variables --

-- Updated the misspelled Crypto Industry name
SELECT DISTINCT(industry) from layoffs_copy1
WHERE industry LIKE "Cryp%";

UPDATE layoffs_copy1
SET industry = 'Crypto'
WHERE industry LIKE 'Cryp%'; 

UPDATE layoffs_copy1
SET company = TRIM(industry);

SELECT DISTINCT(country) FROM layoffs_copy1
ORDER BY country asc;  -- United States has misspelled --

-- Updated misspelled United State --
SELECT DISTINCT country FROM layoffs_copy1
WHERE country like "United St%";


UPDATE layoffs_copy1
SET country = TRIM(TRAILING '.' FROM country)
WHERE country LIKE 'United St%'; 

-- There is typo error of location.
SELECT DISTINCT(location) FROM layoffs_copy1
ORDER BY location asc;  				

-- updating 'DÃ¼sseldorf' to 'Dusseldorf' (GERMANy)
SELECT DISTINCT location FROM layoffs_copy1 
WHERE location like "%sseldorf"; 

UPDATE layoffs_copy1
SET location = 'Dusseldorf'
WHERE location like "%sseldorf"; 

-- Updating 'FlorianÃ³polis' to Florianópolis (Brazill)
SELECT DISTINCT location FROM layoffs_copy1 
WHERE location like "%Flor%";  	 

UPDATE layoffs_copy1
SET location = "Florianópolis"
WHERE location like "%Flor%";

-- Updating  'MalmÃ¶' to 'Malmo' (Sweden)
SELECT DISTINCT location from layoffs_copy1 
WHERE location LIKE "Malm%";

Update layoffs_copy1
SET location = 'Malmo'
WHERE location LIKE "Malm%";

SELECT * FROM layoffs_copy1;  -- Looking for misreprasentated worde in stage

SELECT DISTINCT stage FROM layoffs_copy1
ORDER BY stage asc;						-- Looks everything is fine in stage columns

-- Updating the date columns --
SELECT `date`, STR_TO_DATE(`date`,'%m/%d/%Y') FROM layoffs_copy1; 

UPDATE layoffs_copy1
SET `date` = STR_TO_DATE(`date`,'%m/%d/%Y');

SELECT `date` FROM layoffs_copy1;

-- Converting data type for date from test to Date -- 
ALTER TABLE layoffs_copy1
MODIFY COLUMN `date` DATE;

SELECT company, industry FROM layoffs_copy1
WHERE industry is NULL OR industry = "";

SELECT * FROM layoffs_copy1
WHERE industry IS NULL;

UPDATE layoffs_copy1
SET industry = null
WHERE industry IS NULL OR industry = '';

UPDATE layoffs_copy1
SET company = null
WHERE company IS NULL OR company = '';

SELECT count(*) FROM layoffs_copy1
WHERE (total_laid_off IS NULL OR total_laid_off = '') OR 
(percentage_laid_off IS NULL OR percentage_laid_off = ''); -- There is total of `1162` rows has null or blank values in total_laid_off and percentage_laid_off

-- Droping `Row_numbers` columns
SELECT * FROM layoffs_copy1; -- check for row_numbers column

DELETE FROM layoffs_copy1
WHERE company IS NULL AND industry is NULL;

ALTER TABLE layoffs_copy1
DROP COLUMN `row_number`;

/*Preserved NULL values in critical columns (total_laid_off, 
percentage_laid_off,funds_raised_millions,date,stage,) for further investigation with the Data Engineering 
team to maintain dataset completeness and avoid premature data loss. */

-- Creating columns for incomplete rows in the Dataset
ALTER TABLE layoffs_copy1
ADD COLUMN data_quality_flag VARCHAR(30);

UPDATE layoffs_copy1
SET data_quality_flag = 
	CASE
		WHEN total_laid_off IS NULL OR percentage_laid_off IS NULL OR funds_raised_millions IS NULL THEN "Incomplete"
        ELSE "Complete"
	END;
  
-- Analyze the number of Incompete and completed rows are there
    SELECT COUNT(*) FROM layoffs_copy1;
    Select data_quality_flag, COUNT(data_quality_flag) FROM layoffs_copy1
    GROUP BY data_quality_flag;
/* - There are totaly 2352 rows amoung them 1263 where Incompleted datasets and 1089 rows are Completed Datasets.
   - Nearly 57 percentage of rows are Incomplete and 46 percentage are Complete rows*/
