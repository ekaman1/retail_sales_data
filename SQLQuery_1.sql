--check for missing or null values
SELECT *
FROM dbo.RetailSales
WHERE Product_ID IS NULL
   OR Product_Category IS NULL
   OR Sales_Amount IS NULL
   OR Quantity_Sold IS NULL
   OR Store_ID IS NULL
   OR Region IS NULL
   OR Customer_ID IS NULL;

--drop row  with missing values
DELETE FROM dbo.RetailSales
WHERE Product_ID IS NULL
   OR Product_Category IS NULL
   OR Sales_Amount IS NULL
   OR Quantity_Sold IS NULL
   OR Store_ID IS NULL
   OR Region IS NULL
   OR Customer_ID IS NULL;

--this code replace missing values with a default value. for example this one replace missing sales amount with 0
UPDATE dbo.RetailSales
SET Sales_Amount = 0
WHERE Sales_Amount IS NULL;

--check and delete duplicate rowa in the dataset
/*
- WITH CTE_Duplicates AS: This creates a CTE (Common Table Expression) named CTE_Duplicates. 
A CTE is a temporary result set that you can reference within a SELECT, INSERT, UPDATE, or DELETE statement.

- ROW_NUMBER() OVER (PARTITION BY Date, Product_ID, Store_ID ORDER BY Date) AS row_num:
    * The ROW_NUMBER() function is used here to assign a row number to each row in the table.
    * The PARTITION BY clause groups rows that have the same values in the Date, Product_ID, and Store_ID columns. In other words, 
        it identifies duplicates based on these three columns.
    * ORDER BY Date ensures that within each group of duplicates (rows with the same Date, Product_ID, and Store_ID), 
        the rows are numbered in the order of the Date column.
    * The row_num is a temporary column created in the CTE that assigns a row number starting from 1 for each partition (group of duplicates).
- FROM dbo.RetailSales: This specifies the table from which the data is being selected (RetailSales).
DELETE FROM CTE_Duplicates WHERE row_num > 1: 
    * This is where the actual deletion occurs.
    * After the CTE creates row numbers for each group of duplicates, the DELETE statement is executed on any row where 
        the row_num is greater than 1 (i.e., the second, third, and so on rows in each group of duplicates).
    * This deletes all but the first occurrence of each duplicate row (since row number 1 is kept).*/
    
WITH CTE_Duplicates AS (
    SELECT *, ROW_NUMBER() OVER(PARTITION BY Date, Product_ID, Store_ID ORDER BY Date) AS row_num
    FROM dbo.RetailSales
)
DELETE FROM CTE_Duplicates
WHERE row_num > 1;

--this code correct each data to its correct datatype
ALTER TABLE dbo.RetailSales
ALTER COLUMN Date DATETIME;

ALTER TABLE dbo.RetailSales
ALTER COLUMN Sales_Amount DECIMAL(10, 2);

ALTER TABLE dbo.RetailSales
ALTER COLUMN Quantity_Sold INT;

/* validate each data range
for example Sales_Amount should not be negative and 
Quantity_Sold shouldn't be less than 0
if any incorrect value is found, the second block of code remove it
*/
SELECT *
FROM dbo.RetailSales
WHERE Sales_Amount < 0
   OR Quantity_Sold <= 0;

DELETE FROM dbo.RetailSales
WHERE Sales_Amount < 0
   OR Quantity_Sold <= 0;

