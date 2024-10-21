# Retail-Sales-Analysis

This project aims to analyze retail sales data using SQL, focusing on various aspects of sales performance, customer behavior, and data cleaning. The analysis covers data exploration, cleaning, and detailed insights into sales patterns.

## Objectives

1. **Set up a retail sales database**: Create and populate a retail sales database with the provided sales data.
2. **Data Cleaning**: Identify and remove any records with missing or null values.
3. **Exploratory Data Analysis (EDA)**: Perform basic exploratory data analysis to understand the dataset.
4. **Business Analysis**: Use SQL to answer specific business questions and derive insights from the sales data.

## Project Structure

### 1. Database Setup

- **Database Creation**: The project starts by creating a database named `p1_retail_db`.
- **Table Creation**: A table named `retail_sales` is created to store the sales data. The table structure includes columns for transaction ID, sale date, sale time, customer ID, gender, age, product category, quantity sold, price per unit, cost of goods sold (COGS), and total sale amount.

```sql
CREATE DATABASE p1_retail_db;

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
```

### 2. Data Exploration & Cleaning

- **Record Count**: Determine the total number of records in the dataset.
- **Customer Count**: Find out how many unique customers are in the dataset.
- **Category Count**: Identify all unique product categories in the dataset.
- **Null Value Check**: Check for any null values in the dataset and delete records with missing data.

**How many total rows are there in the dataset?**

```sql
SELECT COUNT(*) 
FROM retail_sales;
```

**How many unique customers are there?**

```sql
SELECT COUNT(DISTINCT customer_id) 
FROM retail_sales;
```

**What are the unique product categories available in the dataset?**

```sql
SELECT DISTINCT category 
FROM retail_sales;
```

**Identify records where any important fields (sale_date, sale_time, customer_id, gender, age, category, quantity, price_per_unit, cogs) are missing**

``sql
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
    ```

 **Delete records where any of the key fields are NULL**

```sql
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
```

### 3. Data Analysis & Findings

The following SQL queries were developed to answer specific business questions:

1. **Retrieve all sales data for transactions made on '2022-11-05'**:

```sql
SELECT *
FROM retail_sales
WHERE sale_date = '2022-11-05';
```

2. **Find transactions in the 'Clothing' category where the quantity sold is more than 3 in November 2022**:

```sql
SELECT * 
FROM retail_sales
WHERE 
    category = 'Clothing'
    AND DATE_FORMAT(sale_date, '%Y-%m') = '2022-11'
    AND quantity > 3;
```

3. **Calculate the total sales (total_sale) for each category and count the number of orders**:

```sql
SELECT 
    category,
    SUM(total_sale) as net_sale,
    COUNT(*) as total_orders
FROM retail_sales
GROUP BY 1;
```

4. **Find the average age of customers who purchased items from the 'Beauty' category**:

```sql
SELECT
    ROUND(AVG(age), 2) as avg_age
FROM retail_sales
WHERE category = 'Beauty'
```

5. **Retrieve all transactions where the total sale amount is greater than 1000**:

```sql
SELECT * FROM retail_sales
WHERE total_sale > 1000
```

6. **Find the total number of transactions made by each gender for each category**:

```sql
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
```

7. **Calculate the average monthly sales and determine the best-selling month for each year**:

```sql
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
```

8. **Identify the top 5 customers based on the highest total sales**:

```sql
SELECT 
    customer_id,
    SUM(total_sale) as total_sales
FROM retail_sales
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5;
```

9. **Find the number of unique customers who purchased items from each category**:

```sql
SELECT 
    category,    
    COUNT(DISTINCT customer_id) as cnt_unique_cs
FROM retail_sales
GROUP BY category
```

10. **Categorize transactions based on the time of day (Morning <12, Afternoon between 12 & 17, Evening >17), and count the number of orders per shift.**:

```sql
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
```

## Findings

- **Customer Demographics**: The dataset includes customers from various age groups, with sales distributed across different categories such as Clothing and Beauty.
- **High-Value Transactions**: Several transactions had a total sale amount greater than 1000, indicating premium purchases.
- **Sales Trends**: Monthly analysis shows variations in sales, helping identify peak seasons.
- **Customer Insights**: The analysis identifies the top-spending customers and the most popular product categories.

## Reports

- **Sales Summary**: A detailed report summarizing total sales, customer demographics, and category performance.
- **Trend Analysis**: Insights into sales trends across different months and shifts.
- **Customer Insights**: Reports on top customers and unique customer counts per category.
