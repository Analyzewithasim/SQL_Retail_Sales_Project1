-- SQL Retail Sales Analysis - P1

-- Create TABLE
DROP TABLE IF EXISTS retail_sales;
CREATE TABLE retail_sales
	(
	transactions_id INT PRIMARY KEY,
	sale_date DATE,
	sale_time TIME,
	customer_id INT,
	gender VARCHAR(15),
	age	INT,
	category VARCHAR(15),
	quantity INT,
	price_per_unit FLOAT,
	cogs FLOAT,
	total_sale FLOAT
	);

SELECT * FROM retail_sales
LIMIT 10;

SELECT COUNT(*)
FROM retail_sales;

-- DATA CLEANING

-- Checking is there are any null values in specific columns
SELECT * FROM retail_sales
WHERE transactions_id IS NULL;

SELECT * FROM retail_sales
WHERE 	sale_time IS NULL;

--Checking null values in one code for the dataset

SELECT * FROM retail_sales
WHERE
	transactions_id IS NULL
	OR sale_date IS NULL
	OR sale_time IS NULL
	OR gender IS NULL
	OR category IS NULL
	OR quantity IS NULL
	OR cogs IS NULL
	OR total_sale IS NULL;

-- DELETE the null values which we having in the dataset

DELETE FROM retail_sales
WHERE
	transactions_id IS NULL
	OR sale_date IS NULL
	OR sale_time IS NULL
	OR gender IS NULL
	OR category IS NULL
	OR quantity IS NULL
	OR cogs IS NULL
	OR total_sale IS NULL;

-- We can see 3 records are deleted which having null values
SELECT COUNT(*)
FROM retail_sales;

-- DATA EXPLORATION

-- How many sales do we have?

SELECT COUNT(*) AS total_sale FROM retail_sales;

SELECT * FROM retail_sales;

-- How many unique customers do we have?

SELECT COUNT(DISTINCT customer_id) AS total_customers
FROM retail_sales;

-- How many unique categories do we have?
SELECT COUNT(DISTINCT category) AS total_categories
FROM retail_sales;

-- What categories do we have in the dataset?
SELECT DISTINCT category
FROM retail_sales;

-- DATA ANALYSIS & BUSINESS KEY PROBLEMS & ANSWERS

-- Q1. Write a SQL query to retrieve all the columns for sales made on '2022-11-05'

SELECT *
FROM retail_sales
WHERE sale_date = '2022-11-05';

-- Q2 Write a SQL query to retrieve all transactions where the category is 'clothing' and the quatity sold is more than 4 in the month of 'Nov 2022'

SELECT transactions_id, category, quantity, sale_date
FROM retail_sales
WHERE category = 'Clothing'
AND quantity >= 4
AND TO_CHAR(sale_date, 'YYYY-MM') = '2022-11' ;

-- Q3 Write a SQL query to calculate the total sales for each category

SELECT category, SUM(total_sale) AS net_sale
FROM retail_sales
GROUP BY category
ORDER BY net_sale;

--Q4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty category'

SELECT ROUND(AVG(age), 2) AS avg_age
FROM retail_sales
WHERE category = 'Beauty';

-- Q5 Write a SQL query to find all transactions where total_sales is greater than 1000

SELECT transactions_id, total_sale
FROM retail_sales
WHERE total_sale >1000;

-- Q6 Write a SQL query to find the total number of transactions(transaction_id) made by each gender in each category

SELECT gender, category, COUNT(transactions_id) AS total_transactions
FROM retail_sales
GROUP BY gender, category;

-- Q7 Write an SQL query to calculate the average sale for each month. and find the best selling month each year.
SELECT year, month, avg_sales FROM
(
SELECT 
EXTRACT(YEAR FROM sale_date) AS year,
EXTRACT(MONTH FROM sale_date) AS month,
AVG(total_sale) AS avg_sales,
RANK () OVER(PARTITION BY EXTRACT(YEAR FROM sale_date) ORDER BY AVG(total_sale) DESC) AS rank
FROM retail_sales
GROUP BY year, month
) AS T1
WHERE rank = 1;
--ORDER BY year, avg_sales DESC;

-- Q8 Write a SQL query to find top 5 Customers based on the highest total sales

SELECT *
FROM retail_sales;

SELECT customer_id AS Customer, SUM(total_sale) AS Highest_Sale
FROM retail_sales
GROUP BY customer_id
ORDER BY Highest_sale DESC
LIMIT 5;

--Q9 Write a SQL query to find the number of unique customers who purchased items from each category

SELECT *

SELECT COUNT(DISTINCT customer_id) AS Unique_Customers, category
FROM retail_sales
GROUP BY category;

--Q10 Write a SQL query to create each shift and number of orders(Example Morning <=12, Afternoon Between 12 & 17, Evening >17)

SELECT * FROM retail_sales;

WITH hourly_sales AS
(
SELECT *,
CASE 
WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN 'Morning'
WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
ELSE 'Evening'
END AS shift
FROM retail_sales
)
SELECT shift, COUNT(transactions_id) AS total_orders
FROM hourly_sales
GROUP BY shift;

-- ENd of the Project