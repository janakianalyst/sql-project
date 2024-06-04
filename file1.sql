create database AmazonDB;
use AmazonDB;
select * from amazon;
/*Approach Used
1.	Data Wrangling:
1.1 Build a database: Set up a database where you'll store your data.
1.2 Create a table and insert the data: Define a table schema that matches the structure of your dataset and insert the data into the table.
1.3 Select columns with null values: Verify if there are any null values in your dataset and handle them appropriately.
There are no null values in our database as in creating the tables, we set NOT  NULL for each field, hence null values are filtered out.
2.	Feature Engineering:
	Feature engineering is the process of creating new features or variables from existing ones to improve the performance of 
	machine learning models or gain insights from the data. In the context of your analysis, 
    feature engineering serves several important purposes:
    By extracting additional information such as time of day, day of the week, and month of the year 
    from the existing columns (time and date) for  understanding sales patterns by time of day (morning, afternoon, evening) and 
    different timescales (daily, weekly, monthly) can help identify peak hours for sales, while analyzing sales trends by day of the week and month of the year 
    can reveal recurring patterns and seasonal variations.

/*1.Add a new column named timeofday to give insight of sales in the Morning, 
Afternoon and Evening. This will help answer the question on which part of the day most sales are made.*/
ALTER TABLE amazon
ADD COLUMN timeofday VARCHAR(20);
UPDATE amazon
SET timeofday = 
    CASE 
        WHEN HOUR(time) >= 0 AND HOUR(time) < 12 THEN 'Morning'
        WHEN HOUR(time) >= 12 AND HOUR(time) < 18 THEN 'Afternoon'
        ELSE 'Evening'
    END;
    
/* 2.Add a new column named dayname that contains the extracted days of the week on which the given transaction took place (Mon, Tue, Wed, Thur, Fri). 
This will help answer the question on which week of the day each branch is busiest.*/

ALTER TABLE amazon
ADD COLUMN dayname VARCHAR(20);
UPDATE amazon
SET dayname = dayname(date);

/*3.Add a new column named monthname that contains the extracted months of the year on which the given transaction took place (Jan, Feb, Mar). 
Help determine which month of the year has the most sales and profit.*/

ALTER TABLE amazon
ADD COLUMN monthname varchar(20);
UPDATE amazon 
set monthname=monthname(date);

/*Analysis List
•	Product Analysis:
Conduct analysis on the data to understand the different product lines, the products lines performing best and the product lines 
that need to be improved.
To conduct a product analysis on the dataset to understand the different product lines,
 identify the best-performing product lines, and determine areas for improvement.
1.	Identify Product Lines:
•	Count the distinct product lines in the dataset.
-- Count distinct product lines*/

SELECT COUNT(DISTINCT `product line`) AS distinct_product_lines
FROM amazon;

/*Determine the list of unique product lines available.
-- List unique product lines*/

SELECT DISTINCT `product line` FROM amazon;

/*Analyze Sales Performance:
Calculate the total sales for each product line.
-- Calculate total sales for each product line*/

SELECT `product line`, SUM(total) AS total_sales
FROM amazon GROUP BY `product line` ORDER BY total_sales DESC;

/*Determine which product lines generate the highest sales revenue.
-- Determine product lines with highest sales revenue*/

SELECT `product line`, SUM(total) AS total_sales
FROM amazon GROUP BY `product line` ORDER BY total_sales DESC LIMIT 6; 

/*calculate total avg sales */
select avg(total) from amazon;

/*Evaluate Product Line Performance:
•	Calculate average sales or revenue for each product line to assess performance.
-- Calculate average sales revenue for each product line*/
SELECT `product line`, AVG(total) AS average_sales FROM amazon GROUP BY `product line` ORDER BY average_sales DESC;

/*Identify product lines with above-average performance as well as those with below-average performance.
-- Identify product lines with above-average performance*/
SELECT `product line`, AVG(total) AS average_sales
FROM amazon GROUP BY `product line`
HAVING AVG(total) > (SELECT AVG(total) FROM amazon);

/*Identify Opportunities for Improvement:
•	Review product lines with below-average performance to understand reasons behind their lower sales.
-- Identify product lines with below-average performance*/
SELECT `product line`, AVG(total) AS average_sales
FROM amazon GROUP BY `product line`
HAVING AVG(total) < (SELECT AVG(total) FROM amazon);
/*
Sales Analysis
This analysis aims to answer the question of the sales trends of product. 
The result of this can help us measure the effectiveness of each sales strategy the business applies
 and what modifications are needed to gain more sales.
To conduct a sales analysis aiming to understand sales trends of products, 
measure the effectiveness of sales strategies, and identify areas for improvement, we can follow these steps:
    Analyze Overall Sales Trends:
•	Calculate total sales over time to understand overall sales trends.
•	Visualize the trend of total sales over time (e.g., monthly or quarterly sales trends).
-- Calculate total sales over time*/
SELECT date, SUM(total) AS total_sales
FROM amazon GROUP BY date ORDER BY date;



/*Evaluate Sales Performance by Product Line:
•	Calculate total sales for each product line to identify top-selling product lines.
•	Analyze sales trends for each product line over time to understand their performance.
-- Calculate total sales for each product line*/
SELECT `product line`, SUM(total) AS total_sales
FROM amazon GROUP BY `product line` ORDER BY total_sales DESC;

/*Assess Sales Performance by Branch:
Calculate total sales for each branch to identify top-performing branches. -- Calculate total sales for each branch*/
SELECT branch, SUM(total) AS total_sales
FROM amazon
GROUP BY branch
ORDER BY total_sales DESC;

/* Identify Seasonal Trends:
•	Analyze sales data to identify seasonal trends or patterns in sales.
-- Analyze sales data to identify seasonal trends
-- we can aggregate sales data by month or quarter and visualize the trend.
--Determine peak seasons or months with highest sales and off-peak seasons.*/
select sum(total) as total_sales,monthname from amazon group by monthname order by total_sales desc;

#identify In which city was the highest revenue recorded?
select sum(Total) as highest_revenue,city from amazon group by city order by highest_revenue desc limit 1;


/*5.	Evaluate Sales by Customer Type:
•	Calculate total sales for each customer type to understand their contribution to overall sales.
•	Analyze sales trends for different customer types to identify key customer segments.
-- Calculate total sales for each customer type*/
SELECT `customer type`, SUM(total) AS total_sales
FROM amazon
GROUP BY `customer type`
ORDER BY total_sales DESC;

/*-
	Assess Sales by Payment Method:
•	Calculate total sales for each payment method to understand payment preferences.
•	Analyze trends in sales by payment method to identify popular payment methods.
-- Calculate total sales for each payment method*/
SELECT payment, SUM(total) AS total_sales
FROM amazon
GROUP BY payment
ORDER BY total_sales DESC;

/*Customer Analysis
This analysis aims to uncover the different customer segments, purchase trends and the profitability of each customer segment.
To conduct a customer analysis aiming to uncover different customer segments, purchase trends, and profitability of each customer segment, you can follow these steps:
Segment Customers:
•	Identify different customer segments based on their characteristics (e.g., customer type, gender, location).
•	Segment customers based on their purchasing behavior (e.g., frequency of purchases, total purchase amount).
-- Segment customers based on customer type*/
SELECT `customer type`, COUNT(*) AS customer_count
FROM amazon
GROUP BY `customer type`;

-- Segment customers based on gender
SELECT gender, COUNT(*) AS customer_count
FROM amazon
GROUP BY gender;
/*Analyze Purchase Trends:
•	Calculate total sales for each customer segment to understand their contribution to overall sales.
•	Analyze purchase trends over time for each customer segment to identify patterns or changes in behavior.
-- Calculate total sales for each customer segment*/
SELECT `customer type`, SUM(total) AS total_sales
FROM amazon
GROUP BY `customer type`
ORDER BY total_sales DESC;

-- Analyze purchase trends over time for each customer segment
-- You can join with the table containing customer sales data by date.
/*Assess Profitability:
•	Calculate gross margin or profit for each customer segment to understand their profitability.
•	Analyze profitability trends over time to identify segments with high or low profitability.
-- Calculate gross margin or profit for each customer segment*/
SELECT `customer type`, SUM(`gross income`) AS total_profit
FROM amazon
GROUP BY `customer type`
ORDER BY total_profit DESC;

/*Identify High-Value Customers:
•	Identify high-value customers based on their total purchase amount or frequency of purchases.
•	Analyze the characteristics and purchasing behavior of high-value customers to understand their importance to the business.
-- Identify high-value customers based on total purchase amount*/
SELECT `invoice id`, SUM(total) AS total_purchase_amount
FROM amazon
GROUP BY `invoice id`
ORDER BY total_purchase_amount DESC
LIMIT 10; 

/* 3. Exploratory Data Analysis (EDA): Exploratory data analysis is done to answer the listed questions and aims of this project.

Business Questions To Answer:*/

/*What is the count of distinct cities in the dataset?*/
select count(distinct(city)) from amazon;

/*For each branch, what is the corresponding city?*/
select city ,branch from amazon group by branch,city;

/*What is the count of distinct product lines in the dataset?*/
SELECT count(Distinct `product line`) from amazon;

/*Which payment method occurs most frequently?*/
select count(payment),payment from amazon group by payment;

/*Which product line has the highest sales?*/
select sum(total),`product line` from amazon group by `product line` order by sum(total) desc limit 1;
/*How much revenue is generated each month?*/
select sum(total),monthname from amazon group by monthname;

/*In which month did the cost of goods sold reach its peak?*/
select sum(cogs),monthname from amazon group by monthname order by sum(cogs) desc;

/*Which product line generated the highest revenue?*/
select sum(total),`product line` from amazon group by `product line` order by sum(total) desc limit 1;

/*In which city was the highest revenue recorded?*/
select sum(Total) as highest_revenue,city from amazon group by city order by highest_revenue desc limit 1;

/*Which product line incurred the highest Value Added Tax?*/
select `product line`,sum(`Tax 5%`) as highest_value from amazon group by `product line`;
/*For each product line, add a column indicating "Good" if its sales are above average, otherwise "Bad."*/
SELECT 
    *,
    CASE 
        WHEN tot_sales > avg_sales THEN 'Good'
        ELSE 'Bad'
    END AS sales_quality
FROM (
    SELECT 
        `product line`,
        SUM(total) AS tot_sales,
        AVG(sum(total)) over()  AS avg_sales
    FROM amazon
    GROUP BY `product line`
) AS subquery;

/*Identify the branch that exceeded the average number of products sold.*/
SELECT 
    branch,
    COUNT(*) AS num_products_sold
FROM 
    amazon
GROUP BY 
    branch
HAVING 
    COUNT(*) > (SELECT AVG(num_products_sold) FROM
    (SELECT COUNT(*) AS num_products_sold FROM amazon GROUP BY branch) AS subquery);

/*Which product line is most frequently associated with each gender?*/
select count(*) as frequency,`product line` ,gender from amazon group by  `product line`,gender order by frequency desc;

/*Calculate the average rating for each product line.*/
select avg(rating) as avg_rating,`product line` from amazon group by `product line` order by avg_rating desc;

/*Count the sales occurrences for each time of day on every weekday.*/
select count(*) as sales_occurances,dayname,timeofday from amazon group by timeofday,dayname order by sales_occurances desc;

/*Identify the customer type contributing the highest revenue.*/
select sum(total) as highest_revenue,`customer type` from amazon group by `customer type` order by highest_revenue desc limit 1;

/*Determine the city with the highest VAT percentage.*/
select city,(sum(`Tax 5%`)/sum(total))*100 as vat_percentage from amazon group by city order by vat_percentage desc limit 1; 
/*Identify the customer type with the highest VAT payments.*/
select `customer type`, sum(`Tax 5%`) as highest_vat_payment from amazon group by `customer type` order by highest_vat_payment desc limit 1; 

/*What is the count of distinct customer types in the dataset?*/
select count(distinct(`customer type`)) as dist_cust_type from amazon;

/*What is the count of distinct payment methods in the dataset?*/
select count(distinct(payment)) as dist_pay_type from amazon;

/*Which customer type occurs most frequently?*/
select count(*)as freq,`customer type` from amazon group by `customer type` order by freq desc ;

/*Identify the customer type with the highest purchase frequency.*/
select `customer type` ,sum(total) from amazon group by `customer type`

/*Determine the predominant gender among customers.*/
select gender,count(*) as predominant from amazon group by gender order by predominant desc limit 1;

/*Examine the distribution of genders within each branch.*/
select branch,gender,count(*) from amazon group by branch,gender order by branch ;
/*Identify the time of day when customers provide the most ratings.*/
select timeofday ,sum(rating) as ratings from amazon group by timeofday order by ratings desc limit 1;
/*Determine the time of day with the highest customer ratings for each branch.*/
select timeofday ,branch,sum(rating) as ratings from amazon group by timeofday,branch order by ratings desc limit 1;

/*Identify the day of the week with the highest average ratings.*/
select dayname ,avg(rating) as ratings from amazon group by dayname order by ratings desc limit 1;

/*Determine the day of the week with the highest average ratings for each branch.*/
select branch,dayname,avg(rating) as ratings from amazon group by dayname,branch order by ratings desc limit 1;


/*Recommendations:
1.  Additional analysis and strategies for improvement based on identified product lines.
	Explore potential strategies to improve sales for these product lines, such as marketing campaigns, promotions, or product improvements.
2.Launch targeted marketing campaigns to promote top-selling products or product lines.
Optimize pricing strategies for products with below-average sales performance to increase competitiveness.
Enhance customer engagement through personalized recommendations or loyalty programs based on customer segmentation.
Improve inventory management processes to ensure adequate stock levels for high-demand products during peak seasons.
Invest in training and development programs to enhance sales team performance and customer service.
Expand product offerings or introduce new product lines based on emerging trends or customer preferences identified in the analysis.
