-- "Step 1: Create Table"
--DROP TABLE IF EXISTS sales;

CREATE TABLE sales (
    Invoice_ID TEXT PRIMARY KEY,
    Branch TEXT,
    City TEXT,
    Customer_type TEXT,
    Gender TEXT,
    Product_line TEXT,
    Unit_price REAL,
    Quantity INTEGER,
    Tax_5 REAL,
    Total REAL,
    Date TEXT,
    Time TEXT,
    Payment TEXT,
    COGS REAL,
    Gross_margin_percentage REAL,
    Gross_income REAL,
    Rating REAL
);

--Use the import function to import supermarketsales_data.csv into the sales table

Select * from sales;

-- "Step 2: Data Cleaning"
-- Check for duplicates
SELECT Invoice_ID, COUNT(*) FROM sales GROUP BY Invoice_ID HAVING COUNT(*) > 1;

-- Check for NULL values
SELECT * FROM sales WHERE 
    Invoice_ID IS NULL OR
    Product_line IS NULL OR
    Unit_price IS NULL;

-- Standardize text fields
UPDATE sales
SET Customer_type = UPPER(Customer_type),
    Payment = UPPER(Payment);

-- "Step 3: Basic Exploration"
-- Top performing branches
SELECT Branch, ROUND(SUM(Total)::NUMERIC, 2) AS Revenue
FROM sales
GROUP BY Branch
ORDER BY Revenue DESC;

-- Most sold product lines
SELECT Product_line, SUM(Quantity) AS Total_Sold
FROM sales
GROUP BY Product_line
ORDER BY Total_Sold DESC;

-- Payment method popularity
SELECT Payment, COUNT(*) AS Count
FROM sales
GROUP BY Payment
ORDER BY Count DESC;

-- Gender distribution
SELECT Gender, COUNT(*) AS Customers
FROM sales
GROUP BY Gender;

-- "Step 4: Business Insights"
-- Best product line by city
SELECT City, Product_line, SUM(Total) AS Revenue
FROM sales
GROUP BY City, Product_line
ORDER BY City, Revenue DESC;

-- Payment method by gender
SELECT Gender, Payment, COUNT(*) AS Count
FROM sales
GROUP BY Gender, Payment
ORDER BY Gender;

-- Average spending by customer type
SELECT Customer_type, ROUND(AVG(Total)::Numeric, 2) AS Avg_Spend
FROM sales
GROUP BY Customer_type;

-- Peak sales day
SELECT Date, ROUND(SUM(Total)::NUMERIC, 2) AS Daily_Sales
FROM sales
GROUP BY Date
ORDER BY Daily_Sales DESC
LIMIT 1;

-- "Step 5: Query Optimization"
-- Query execution plan
EXPLAIN ANALYZE
SELECT Product_line, SUM(Quantity)
FROM sales
GROUP BY Product_line;

-- Partition revenue by branch using window function
SELECT Branch, City, Total,
       SUM(Total) OVER (PARTITION BY Branch ORDER BY Date) AS Cumulative_Sales
FROM sales;

