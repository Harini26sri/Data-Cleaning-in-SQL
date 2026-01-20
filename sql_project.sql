-- DATA CLEANING

SELECT * 
FROM layoffs;

-- 1. REMOVE THE DUPLICATES 
-- 2 . NULL VALUES OR EMPTY VALUES
-- 3. STANDARDIZE THE DATA
-- 4.REMOVE ANY TABLE

CREATE TABLE layoffs_staging
LIKE layoffs;

SELECT * 
FROM layoffs_staging;

INSERT INTO layoffs_staging
SELECT * FROM
layoffs;


WITH cte_duplicate AS 
(
SELECT * ,
ROW_NUMBER() OVER(PARTITION BY company,location,industry,total_laid_off,percentage_laid_off,
`date`,stage,country,funds_raised_millions) as row_num
FROM layoffs_staging
)
SELECT * 
FROM cte_duplicate
where row_num > 1;



CREATE TABLE `layoffs_staging2` (
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


SELECT * FROM
layoffs_staging2

INSERT INTO layoffs_staging2
SELECT * ,
ROW_NUMBER() OVER(PARTITION BY company,location,industry,total_laid_off,percentage_laid_off,
`date`,stage,country,funds_raised_millions) as row_num
FROM layoffs_staging;


SELECT * FROM
layoffs_staging2
WHERE row_num > 1;

DELETE FROM
layoffs_staging2
WHERE row_num > 1;




