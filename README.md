# Layoffs-Data-Cleaning-Project-MySQL-

## Project Summary:
This project focuses on cleaning a real-world layoffs dataset using MySQL. The dataset contained inconsistencies such as duplicates, misspellings and missing values. A structured approach was followed to ensure the data is standardized, deduplicated, and prepared for downstream analytics.

### Key Steps Involved:

 - Created a working copy of the original dataset to preserve raw data.
 - Identified and removed duplicate records using `ROW_NUMBER()` and `CTEs`.
 - Standardized values for `company`, `industry`, `location`, `country`, and `date`.
 - Corrected character encoding issues (e.g., “DÃ¼sseldorf” → “Dusseldorf”).
 - Converted date strings to proper DATE format using STR_TO_DATE.
 - Preserved NULL values in key columns (total_laid_off, percentage_laid_off, etc.) for further investigation to avoid premature data loss.
 - Added a `data_quality_flag` column to mark rows as Complete or Incomplete.

### Data Quality Insights:

 - Total Rows: 2,352
 - Incomplete Rows: 1,263 (~57%)
 - Complete Rows: 1,089 (~43%)


**Tools Used:** MySQL, CTEs, window functions, conditional logic, TRIM, string operations.
