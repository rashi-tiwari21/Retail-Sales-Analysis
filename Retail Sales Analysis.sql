-- Retail Sales Analysis

CREATE DATABASE p1_retail_db;

-- Ceate Table
CREATE TABLE retail_sales
(
    transactions_id INT PRIMARY KEY,
    sale_date DATE,	
    sale_time TIME,
    customer_id INT,	
    gender VARCHAR(10),
    age INT,
    category VARCHAR(35),
    quantity INT,
    price_per_unit FLOAT,	
    cogs FLOAT,
    total_sale FLOAT
);

SELECT * 
FROM retail_sales;

-- Data Cleaning 

-- How many total rows are there in the dataset?

SELECT COUNT(*) 
FROM retail_sales;

-- How many unique customers are there?

SELECT COUNT(DISTINCT customer_id) 
FROM retail_sales;

-- What are the unique product categories available in the dataset?

SELECT DISTINCT category 
FROM retail_sales;

-- Identify records where any important fields (sale_date, sale_time, customer_id, gender, age, category, quantity, price_per_unit, cogs) are missing.

SELECT * 
FROM retail_sales
WHERE 
    sale_date IS NULL 
    OR 
    sale_time IS NULL 
    OR 
    customer_id IS NULL 
    OR 
    gender IS NULL 
    OR 
    age IS NULL 
    OR 
    category IS NULL 
    OR 
    quantity IS NULL 
    OR 
    price_per_unit IS NULL 
    OR 
    cogs IS NULL;


-- Delete records where any of the key fields are NULL.

DELETE FROM retail_sales
WHERE 
    sale_date IS NULL 
    OR 
    sale_time IS NULL 
    OR 
    customer_id IS NULL 
    OR 
    gender IS NULL 
    OR 
    age IS NULL 
    OR 
    category IS NULL 
    OR 
    quantity IS NULL 
    OR 
    price_per_unit IS NULL 
    OR 
    cogs IS NULL;
    
    
-- Data Exploaration
    
-- 1. Retrieve all sales data for transactions made on '2022-11-05'.
    
SELECT *
FROM retail_sales
WHERE sale_date = '2022-11-05';

-- 2. Find transactions in the 'Clothing' category where the quantity sold is more than 3 in November 2022
    
SELECT * 
FROM retail_sales
WHERE 
    category = 'Clothing'
    AND DATE_FORMAT(sale_date, '%Y-%m') = '2022-11'
    AND quantity > 3;
    

-- 3.Calculate the total sales (total_sale) for each category and count the number of orders.

SELECT 
category, 
SUM(total_sale) as net_sale,
COUNT(*) as total_orders
FROM retail_sales
GROUP BY 1;

--  4.Find the average age of customers who purchased items from the 'Beauty' category

SELECT
    ROUND(AVG(age), 2) as avg_age
FROM retail_sales
WHERE category = 'Beauty';

-- 5. Retrieve all transactions where the total sale amount is greater than 1000

SELECT * 
FROM retail_sales
WHERE total_sale > 1000;

-- 6.Find the total number of transactions made by each gender for each category

SELECT 
    category,
    gender,
    COUNT(*) as total_trans
FROM retail_sales
GROUP 
    BY 
    category,
    gender
ORDER BY 1;

-- 7.Calculate the average monthly sales and determine the best-selling month for each year.

SELECT 
    year, 
    month, 
    avg_sale
FROM (
    SELECT 
        EXTRACT(YEAR FROM sale_date) AS year,
        EXTRACT(MONTH FROM sale_date) AS month,
        AVG(total_sale) AS avg_sale,
        RANK() OVER (PARTITION BY EXTRACT(YEAR FROM sale_date) ORDER BY AVG(total_sale) DESC) AS ranking
    FROM retail_sales
    GROUP BY EXTRACT(YEAR FROM sale_date), EXTRACT(MONTH FROM sale_date)
) AS monthly_sales
WHERE ranking = 1;


-- 8. Identify the top 5 customers based on the highest total sales.

SELECT 
    customer_id,
    SUM(total_sale) as total_sales
FROM retail_sales
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5;

-- 9. Find the number of unique customers who purchased items from each category

SELECT 
    category,    
    COUNT(DISTINCT customer_id) as cnt_unique_cs
FROM retail_sales
GROUP BY category;

-- 10. Categorize transactions based on the time of day (Morning <12, Afternoon between 12 & 17, Evening >17), and count the number of orders per shift.

WITH hourly_sale
AS
(
SELECT *,
    CASE
        WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN 'Morning'
        WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
        ELSE 'Evening'
    END as shift
FROM retail_sales
)
SELECT 
    shift,
    COUNT(*) as total_orders    
FROM hourly_sale
GROUP BY shift;


