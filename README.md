# Walmart Sales Data Analysis

## Table of Contents
1. [About](#about)
2. [Purpose of the Project](#purpose-of-the-project)
3. [About Data](#about-data)
4. [Analysis List](#analysis-list)
5. [Approach Used](#approach-used)
6. [Business Questions To Answer](#business-questions-to-answer)
7. [Revenue And Profit Calculations](#revenue-and-profit-calculations)
8. [Code](#code)
9. [Conclusion](#conclusion)

## About

This project aims to explore the Walmart Sales data to understand top-performing branches and products, sales trends of different products, and customer behavior. The dataset was obtained from the [Kaggle Walmart Sales Forecasting Competition](https://www.kaggle.com/c/walmart-recruiting-store-sales-forecasting).

"In this recruiting competition, job-seekers are provided with historical sales data for 45 Walmart stores located in different regions. Each store contains many departments, and participants must project the sales for each department in each store. To add to the challenge, selected holiday markdown events are included in the dataset. These markdowns are known to affect sales, but it is challenging to predict which departments are affected and the extent of the impact." [source](https://www.kaggle.com/c/walmart-recruiting-store-sales-forecasting)

## Purpose of the Project

The major aim of this project is to gain insight into the sales data of Walmart to understand the different factors that affect sales of the different branches.

## About Data

The dataset was obtained from the [Kaggle Walmart Sales Forecasting Competition](https://www.kaggle.com/c/walmart-recruiting-store-sales-forecasting). This dataset contains sales transactions from three different branches of Walmart, respectively located in Mandalay, Yangon, and Naypyitaw. The data contains 17 columns and 1000 rows:

| Column                  | Description                             | Data Type      |
| :---------------------- | :-------------------------------------- | :------------- |
| invoice_id              | Invoice of the sales made               | VARCHAR(30)    |
| branch                  | Branch at which sales were made         | VARCHAR(5)     |
| city                    | The location of the branch              | VARCHAR(30)    |
| customer_type           | The type of the customer                | VARCHAR(30)    |
| gender                  | Gender of the customer making purchase  | VARCHAR(10)    |
| product_line            | Product line of the product sold        | VARCHAR(100)   |
| unit_price              | The price of each product               | DECIMAL(10, 2) |
| quantity                | The amount of the product sold          | INT            |
| VAT                 | The amount of tax on the purchase       | FLOAT(6, 4)    |
| total                   | The total cost of the purchase          | DECIMAL(10, 2) |
| date                    | The date on which the purchase was made | DATE           |
| time                    | The time at which the purchase was made | TIMESTAMP      |
| payment_method                 | The total amount paid                   | DECIMAL(10, 2) |
| cogs                    | Cost Of Goods sold                      | DECIMAL(10, 2) |
| gross_margin_percentage | Gross margin percentage                 | FLOAT(11, 9)   |
| gross_income            | Gross Income                            | DECIMAL(10, 2) |
| rating                  | Rating                                  | FLOAT(2, 1)    |

### Analysis List

1. Product Analysis
2. Sales Analysis
3. Customer Analysis

## Approach Used

1. **Data Wrangling:**
   - Build a database
   - Create table and insert the data.
   - Select columns with null values in them. There are no null values in our database as in creating the tables, we set **NOT NULL** for each field, hence null values are filtered out.

2. **Feature Engineering:**
   - Add a new column named `time_of_day` to give insight into sales in the Morning, Afternoon, and Evening.
   - Add a new column named `day_name` that contains the extracted days of the week on which the given transaction took place (Mon, Tue, Wed, Thur, Fri).
   - Add a new column named `month_name` that contains the extracted months of the year on which the given transaction took place (Jan, Feb, Mar).

3. **Exploratory Data Analysis (EDA):** 
   - Exploratory data analysis is done to answer the listed questions and aims of this project.

## Business Questions To Answer

### Generic Questions
1. How many unique cities does the data have?
2. In which city is each branch?

### Product
1. How many unique product lines does the data have?
2. Which is the most selling payment method?
3. What is the most selling product line?
4. What is the total revenue by month?
5. Which month has the largest COGS(Cost of Goods Sold)?
6. Which product line has the largest revenue?
7. Which city has the largest revenue?
8. Which product line has the largest VAT?
9. Which branch sold more products than the average product sold?
11. What is the most common product line by gender?
12. What is the average rating of each product line?

### Sales
1. Number of sales made in each time of the day per weekday.
2. Which of the customer types brings the most revenue?
3. Which city has the largest tax/VAT percent?
4. Which customer type pays the most VAT?

### Customer
1. How many unique customer types does the data have?
2. How many unique payment methods does the data have?
3. What is the most common customer type?
4. Which customer type buys the most?
5. What is the gender of most of the customers by type?
6. What is the gender distribution per branch?
7. Which time of the day do customers give most ratings?
8. Which time of the day do customers give most ratings per branch?
9. Which day of the week has the best average ratings?
10. Which day of the week has the best average ratings per branch?

## Revenue And Profit Calculations

$ COGS = unitPrice \times quantity $

$ VAT = 5\% \times COGS $

$ total(gross_sales) = VAT + COGS $

$ grossProfit(grossIncome) = total(gross_sales) - COGS $

**Gross Margin** is gross profit expressed as a percentage of the total (gross profit/revenue).

$ \text{Gross Margin} = \frac{\text{gross income}}{\text{total revenue}} $

### Example with the first row in our DB:

**Data given:**
- $ \text{Unit Price} = 45.79 $
- $ \text{Quantity} = 7 $

$ COGS = 45.79 \times 7 = 320.53 $

$ \text{VAT} = 5\% \times 320.53 = 16.0265 $

$ total = VAT + COGS = 16.0265 + 320.53 = 336.5565$

$ \text{Gross Margin Percentage} = \frac{\text{gross income}}{\text{total revenue}} =\frac{16.0265}{336.5565} = 0.047619 \approx 4.7619\% $

## Code

```sql
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
```
## Conclusion

In conclusion, this project aimed to analyze Walmart sales data to gain insights into various aspects such as product performance, sales trends, and customer behavior. By answering the business questions outlined in this README and performing revenue and profit calculations, we have been able to extract valuable insights that can inform strategic decision-making and improve sales strategies.
