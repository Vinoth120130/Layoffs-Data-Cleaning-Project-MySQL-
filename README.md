# Layoffs-Data-Cleaning-Project-MySQL
---

## Project Summary:
This project focuses on cleaning a real-world layoffs dataset using **MySQL**. The raw dataset contained several common data quality issues such as duplicates, inconsistent text formats, character encoding problems, and missing values. A structured, SQL-based approach was applied to clean and prepare the data for further analysis or reporting.

---

## Key Data Cleaning Steps

- Created a working copy to preserve the original dataset  
- Removed duplicate records using `ROW_NUMBER()` with CTEs  
- Standardized text values in columns like `company`, `industry`, `location`, and `country`  
- Corrected character encoding issues (e.g., `DÃ¼sseldorf` → `Dusseldorf`)  
- Converted text-based `date` to proper `DATE` format using `STR_TO_DATE()`  
- Trimmed extra whitespace using `TRIM()`  
- Preserved critical NULL values in `total_laid_off`, `percentage_laid_off`, etc., for further investigation  
- Added a `data_quality_flag` column to mark rows as `Complete` or `Incomplete`

---

##  Data Quality Insights

| Metric             | Value  |
|--------------------|--------|
| Total Rows         | 2,352  |
| Complete Rows      | 1,089  |
| Incomplete Rows    | 1,263  |
| % Incomplete Rows  | ~57%   |
| % Complete Rows    | ~43%   |    

---

## Tools & Concepts Used
- MySQL
- CTEs (Common Table Expressions)
- Window Functions (`ROW_NUMBER()`)
- Conditional Logic (`CASE`, `IF`)
- String Functions (`TRIM`, `LIKE`)
- Data Type Conversion (`STR_TO_DATE()`)
- Data Profiling

## Files Included

- `layoffs_raw.csv` – Original raw dataset
- `layoffs_cleaned.csv` – Cleaned and standardized dataset
- `layoffs_data_cleaning.sql` – Full SQL script for cleaning steps

---

## Additional Notes

- **Why NULLs were preserved**: NULLs in key columns (e.g., `total_laid_off`, `percentage_laid_off`) were kept to avoid unintentional data loss and will be resolved in coordination with Data Engineering or Business teams.
- This project simulates a real-world business case of data pipeline cleaning before analytics or reporting.

---

## How to Run This Project

1. Clone this repo  
2. Load the `layoffs_raw.csv` into your MySQL server  
3. Run `layoffs_data_cleaning.sql` step by step  
4. Export the final cleaned table to `layoffs_cleaned.csv`
