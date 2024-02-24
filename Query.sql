CREATE DATABASE IF NOT EXISTS walmartSales;
use walmartSales;

-- Create table
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



-- Add the time_of_day column
SELECT
	time,
	(CASE
		WHEN `time` BETWEEN "00:00:00" AND "12:00:00" THEN "Morning"
        WHEN `time` BETWEEN "12:01:00" AND "16:00:00" THEN "Afternoon"
        ELSE "Evening"
    END) AS time_of_day
FROM sales;


ALTER TABLE sales ADD COLUMN time_of_day VARCHAR(20);

-- For this to work turn off safe mode for update
-- Edit > Preferences > SQL Edito > scroll down and toggle safe mode
-- Reconnect to MySQL: Query > Reconnect to server
UPDATE sales
SET time_of_day = (
	CASE
		WHEN `time` BETWEEN "00:00:00" AND "12:00:00" THEN "Morning"
        WHEN `time` BETWEEN "12:01:00" AND "16:00:00" THEN "Afternoon"
        ELSE "Evening"
    END
);


-- Add day_name column
SELECT
	date,
	DAYNAME(date)
FROM sales;

ALTER TABLE sales ADD COLUMN day_name VARCHAR(10);

UPDATE sales
SET day_name = DAYNAME(date);


-- Add month_name column
SELECT
	date,
	MONTHNAME(date)
FROM sales;

ALTER TABLE sales ADD COLUMN month_name VARCHAR(10);

UPDATE sales
SET month_name = MONTHNAME(date);

-- --------------------------------------------------------------------
-- ---------------------------- Generic ------------------------------
-- --------------------------------------------------------------------
-- How many unique cities does the data have?
SELECT 
	DISTINCT city
FROM sales;

-- In which city is each branch?
SELECT 
	DISTINCT city,
    branch
FROM sales;

-- --------------------------------------------------------------------
-- ---------------------------- Product -------------------------------
-- --------------------------------------------------------------------

-- How many unique product lines does the data have?
SELECT
	DISTINCT product_line
FROM sales;

-- What is the most common payment method?
select distinct payment, count(payment) as payment_method_used
from sales
group by payment
order by payment_method_used DESC;

-- What is the most selling product line
SELECT
	SUM(quantity) as qty,
    product_line
FROM sales
GROUP BY product_line
ORDER BY qty DESC;

-- What is the total revenue by month

select
	month_name as month, 
	sum(total) as total_revenue
from sales
group by month
order by month DESC;

-- What month had the largest COGS?
select 
	distinct month_name as month,
    sum(cogs) as total_cogs
from sales
group by month
order by month DESC;

-- What product line had the largest revenue?
select 
	distinct product_line, 
    sum(total) as total_revenue 
from sales
group by product_line
order by total_revenue DESC;

-- What is the city with the largest revenue?
select 
	distinct city, 
    sum(total) as total_revenue 
from sales
group by city
order by total_revenue DESC;

-- What product line had the largest VAT?
select 
	distinct product_line, 
    sum(tax_pct) as vat
from sales
group by product_line
order by vat desc;

-- Which branch sold more products than average product sold?
select 
	branch,
	sum(quantity) as qty
from sales
group by branch
having sum(quantity) > (select avg(quantity) from sales);

-- What is the most common product line by gender?
select 
	gender,
    product_line,
    count(gender) as cnt
from sales
group by gender, product_line
order by cnt desc;

-- What is the average rating of each product line?
select 
	product_line,
    avg(rating) as avg_rate
from sales
group by product_line
order by avg_rate;

-- Number of sales made in each time of the day per weekday
select time_of_day,
count(*) as total_sales
from sales
where day_name = "sunday"
group by time_of_day;

-- Which of the customer types brings the most revenue?
select customer_type, sum(total) as total_rev
from sales
group by customer_type;

-- Which city has the largest tax percent/ VAT (Value Added Tax)?
select distinct city, AVG(tax_pct) as VAT
from sales
group by city
order by VAT ;

-- Which customer type pays the most in VAT?
select customer_type, avg(tax_pct) as VAT
from sales
group by customer_type
order by VAT;

-- How many unique customer types does the data have?
select  count(distinct customer_type) as unique_cust
from sales;

-- How many unique payment methods does the data have?
select count(distinct payment) as unique_payment
from sales;

-- What is the most common customer type?
select customer_type, count(customer_type) as cust
from sales
group by customer_type
order by cust;

-- Which customer type buys the most?
select customer_type, count(quantity) as qty
from sales
group by customer_type
order by qty;

-- What is the gender of most of the customers?
select gender, count(gender) as num_of_gender
from sales
group by gender
order by num_of_gender;

-- What is the gender distribution per branch?
select gender, count(branch) as distribution_per_branch
from sales
group by gender
order by distribution_per_branch;

-- Which time of the day do customers give most ratings?
select time_of_day, count(rating) as rate
from sales
group by time_of_day
order by rate;

-- Which time of the day do customers give most ratings per branch?
select time_of_day, branch, avg(rating) as rate
from sales
group by time_of_day, branch
order by rate;

-- Which day of the week has the best avg ratings?
select day_name, avg(rating) as rate
from sales
group by day_name
order by rate;

-- Which day of the week has the best average ratings per branch?
select day_name, branch, avg(rating) as rate
from sales
group by day_name, branch
order by rate;


