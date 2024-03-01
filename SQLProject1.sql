-- Create the database
CREATE DATABASE IF NOT EXISTS WalmartSalesData;

-- Create the table
CREATE TABLE IF NOT EXISTS sales(
	invoice_id VARCHAR(30) NOT NULL PRIMARY KEY,
    branch VARCHAR(5) NOT NULL,
    city VARCHAR(30) NOT NULL,
    customer_type VARCHAR(30) NOT NULL,
    gender VARCHAR(30) NOT NULL,
    product_line VARCHAR(100) NOT NULL,
    unit_price DECIMAL(10,2) NOT NULL,
    quantity INT NOT NULL,
    tax_pct FLOAT(6,4) NOT NULL,
    total DECIMAL(12, 4) NOT NULL,
    date DATETIME NOT NULL,
    time TIME NOT NULL,
    payment VARCHAR(15) NOT NULL,
    cogs DECIMAL(10,2) NOT NULL,
    gross_margin_pct FLOAT(11,9),
    gross_income DECIMAL(12, 4),
    rating FLOAT(2, 1)
);

-- Show complete data

SELECT *
FROM sales;

-- -------------------------------------------------------------------
-- ----------------------- Feature Engineering -----------------------
-- -------------------------------------------------------------------

-- Adding time_of_day column

SELECT
	time,
	(CASE
		WHEN `time` BETWEEN "00:00:00" AND "12:00:00" THEN "Morning"
        WHEN `time` BETWEEN "12:01:00" AND "16:00:00" THEN "Afternoon"
        ELSE "Evening"
    END) AS time_of_day
FROM sales;

ALTER TABLE sales
ADD COLUMN time_of_day VARCHAR(20);

/*
	For this to work, turn off safe mode for update
	Edit > Preferences > SQL Editor > scroll down and turn off safe mode
	then, Reconnect to MySQL: Query > Reconnect to server
*/

UPDATE sales
SET time_of_day = (
	CASE
		WHEN `time` BETWEEN "00:00:00" AND "12:00:00" THEN "Morning"
        WHEN `time` BETWEEN "12:01:00" AND "16:00:00" THEN "Afternoon"
        ELSE "Evening"
    END
); 

-- Adding day_name column

SELECT 
	date,
    DAYNAME(date)
FROM sales;

ALTER TABLE sales
ADD COLUMN day_name VARCHAR(10);

UPDATE sales
SET day_name = DAYNAME(date);

-- Adding month_name column

SELECT 
	date,
    MONTHNAME(date)
FROM sales;

ALTER TABLE sales
ADD COLUMN month_name VARCHAR(10);

UPDATE sales
SET month_name = MONTHNAME(date);

-- --------------------------------------------------------------------
-- ------------------------ Generic Information -----------------------
-- --------------------------------------------------------------------

-- How many unique cities does the data have?

SELECT COUNT(DISTINCT city) AS City_Count
FROM sales;

SELECT DISTINCT city
FROM sales;

-- In which city is each branch?
 
 SELECT DISTINCT branch
FROM sales;

SELECT DISTINCT city, branch
FROM sales;

-- --------------------------------------------------------------------
-- ----------------------- Products Information -----------------------
-- --------------------------------------------------------------------

-- How many unique product lines does the data have?

SELECT COUNT(DISTINCT product_line) AS ProductLine_Count
FROM sales;

SELECT DISTINCT product_line
FROM sales;

-- Which is the most selling payment method?

SELECT payment, COUNT(payment) AS count
FROM sales
GROUP BY payment
ORDER BY count DESC
LIMIT 1;

-- Which is the most selling product line?

SELECT product_line, COUNT(product_line) AS count
FROM sales
GROUP BY product_line
ORDER BY count DESC
LIMIT 1;
 
 -- What is the total revenue by month?
 
 SELECT month_name AS month,
 ROUND(SUM(total),2) AS total_revenue
 FROM sales
 GROUP BY month_name
 ORDER BY total_revenue;

-- Which month has the largest COGS(Cost of Goods Sold)?

SELECT month_name AS month,
ROUND(SUM(cogs),2) AS total_cogs
FROM sales
GROUP BY month_name
ORDER BY total_cogs;
 
 -- Which product line has the largest revenue?
 
SELECT product_line,
ROUND(SUM(total),2) AS total_revenue
FROM sales
GROUP BY product_line
ORDER BY total_revenue DESC
LIMIT 1;
 
 -- Which city has the largest revenue?
 
 SELECT city,
 ROUND(SUM(total),2) AS total_revenue
 FROM sales
 GROUP BY city
 ORDER BY total_revenue DESC
 LIMIT 1;

-- Which product line has the largest VAT?

SELECT product_line,
ROUND(AVG(tax_pct),2) AS VAT
FROM sales
GROUP BY product_line
ORDER BY VAT DESC
LIMIT 1;

-- Which branch sold more products than average products sold?

SELECT branch,
ROUND(SUM(quantity),2) AS QTY
FROM sales
GROUP BY branch
HAVING ROUND(SUM(quantity),2) > (SELECT AVG(quantity) FROM sales)
ORDER BY QTY DESC
LIMIT 1;

-- What is the most common product line by gender?

SELECT
	gender,
    product_line,
    COUNT(gender) AS gender_count
FROM sales
GROUP BY gender, product_line
ORDER BY gender_count DESC;

-- What is the average rating of each product line?

SELECT
	product_line,
	ROUND(AVG(rating), 2) as avg_rating
FROM sales
GROUP BY product_line
ORDER BY avg_rating DESC;

-- --------------------------------------------------------------------
-- ----------------------- Sales Information -----------------------
-- --------------------------------------------------------------------

-- Number of sales made in each time of the day per weekday

SELECT
		time_of_day,
        COUNT(*) AS total_sales
FROM sales
WHERE day_name = "Monday"
GROUP BY time_of_day
ORDER BY total_sales DESC;

-- Which of the customer type brings the most revenue?

SELECT
	customer_type,
    ROUND(SUM(total),2) AS Revenue
FROM sales
GROUP BY customer_type
ORDER BY Revenue DESC
LIMIT 1; 

-- Which city has the largest tax/VAT percent?

SELECT
	city,
    ROUND(AVG(tax_pct),2) AS VAT
FROM sales
GROUP BY city
ORDER BY VAT DESC
LIMIT 1;

-- Which customer type pays the most in VAT?

SELECT
	customer_type,
    ROUND(AVG(tax_pct),2) AS VAT
FROM sales
GROUP BY customer_type
ORDER BY VAT DESC
LIMIT 1;

-- --------------------------------------------------------------------
-- --------------------- Customer Information -------------------------
-- --------------------------------------------------------------------

-- How many unique customer types does the data have?

SELECT 
	DISTINCT customer_type
FROM sales;

-- How many unique Payment method types does the data have?

SELECT 
	DISTINCT payment
FROM sales;

-- Which customer type buys the most?

SELECT 
	customer_type,
    COUNT(customer_type) AS count
FROM sales
GROUP BY customer_type
ORDER BY count DESC;

-- What is the gender of most of the customers?

SELECT
	gender,
    COUNT(gender) AS count
FROM sales
GROUP BY gender
ORDER BY count DESC;
	
-- What is the gender of most of the customers by type?

SELECT
	gender,
    customer_type,
    COUNT(gender) AS count
FROM sales
GROUP BY gender, customer_type
ORDER BY count DESC;

-- What is the gender distribution per branch?

SELECT
	gender,
    branch,
    COUNT(gender) AS count
FROM sales
GROUP BY gender, branch
ORDER BY branch, gender;

-- Which time of the day do customers give most ratings?

SELECT 
	time_of_day,
    ROUND(AVG(rating),2) AS avg_rating
FROM sales
GROUP BY time_of_day
ORDER BY avg_rating DESC;

-- Which time of the day do customers give most ratings per branch?

SELECT 
	time_of_day,
    branch,
    ROUND(AVG(rating),2) AS avg_rating
FROM sales
GROUP BY time_of_day, branch
ORDER BY avg_rating DESC;

-- Which day of the week has the best average rating?

SELECT
    day_name,
    ROUND(AVG(rating),2) AS avg_rating
FROM sales
GROUP BY day_name
ORDER BY avg_rating DESC;

-- Which day of the week has the best average rating per branch?

SELECT
    day_name,
    branch,
    ROUND(AVG(rating),2) AS avg_rating
FROM sales
GROUP BY day_name, branch
ORDER BY avg_rating DESC;
