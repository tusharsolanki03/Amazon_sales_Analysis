use amazon;
select * from amazon;

-- create a table as sales_amazon added the columns --
create table sales_amazon(
Invoice_ID char(50) not null,
Branch varchar(50)  not null,
City varchar(50)  not null,
Customer_type varchar(50)  not null,
Gender varchar(50)  not null,
Product_line varchar(50)  not null,
Unit_price decimal(10,2) not null,
Quantity int not null ,
vat decimal(10,4) not null,
Total decimal(10,4) not null,
Datee Date not null ,
Timee time not null ,
Payment varchar(50)  not null,
cogs decimal(10,4) not null ,
gross_margin_percentage decimal(10,5) not null,
gross_income decimal(10,5) not null,
Rating decimal(10,2) not null,
primary key (Invoice_ID)
);

select * from sales_amazon;

drop table sales_amazon;

-- feature engineering --

ALTER TABLE amazon ADD COLUMN timeofday VARCHAR(10);

UPDATE amazon
SET timeofday = CASE
    WHEN HOUR(Timee) BETWEEN 6 AND 11 THEN 'Morning'
    WHEN HOUR(Timee) BETWEEN 12 AND 17 THEN 'Afternoon'
    Else 'Evening'
END;

SELECT timee, timeofday from amazon;


alter table amazon add column day_name varchar(50);

UPDATE amazon 
SET day_name = DAYNAME(STR_TO_DATE(datee, '%d-%m-%Y'));

select datee,day_name
from amazon;

alter table amazon add column month_name varchar(50);
UPDATE amazon 
SET month_name = MONTHNAME(STR_TO_DATE(datee, '%d-%m-%Y'));

select datee,month_name
from amazon;

-- EDA( EXPLORATORY DATA ANALYSIS)--
SELECT COUNT(*) AS Total_Rows FROM amazon;
SELECT COUNT(*) AS Total_Columns FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='AMAZON';
DESCRIBE AMAZON;
-- Approach Used
-- Data Wrangling: This is the first step where inspection of data is done to make sure NULL values and missing values are detected and data replacement methods are used to replace missing or NULL values.
-- 1.1          Build a database
-- 1.2          Create a table and insert the data.
-- 1.3          Select columns with null values in them. There are no null values in our database as in creating the tables, we set NOT  NULL for each field, hence null values are filtered out.

# 1 What is the count of distinct cities in the dataset?
SELECT COUNT(distinct City) AS DISTINCT_CITY_COUNT
FROM amazon;

# 2 For each branch, what is the corresponding city?
select branch,city from amazon
group by branch,city
order by branch ;

# 3 What is the count of distinct product lines in the dataset?
select count(distinct Product_line) as distinct_product_line from amazon;

# 4 Which payment method occurs most frequently?
select payment,count(*) as frequent_payment_method 
from amazon
group by payment
order by payment desc
limit 1;

# 5 Which product line has the highest sales?
select product_line, sum(total) as sales
from amazon
group by product_line
order by sales
limit 1;

# 6 How much revenue is generated each month?
select monthname(str_to_date(datee,"%d-%m-%y"))as month, sum(cogs) as total_cogs
from amazon
group by monthname(str_to_date(datee,"%d-%m-%y"));

# 7 In which month did the cost of goods sold reach its peak?
select monthname(str_to_date(datee,"%d-%m-%y"))as month, sum(cogs) as total_cogs
from amazon
group by monthname(str_to_date(datee,"%d-%m-%y"))
order by total_cogs desc
limit 1;

# 8 Which product line generated the highest revenue?
select product_line,sum(total) as total_revenue
from amazon
group by product_line
order by total_revenue desc
limit 1;

# 9 In which city was the highest revenue recorded?
select city,sum(total) as total_revenue
from amazon
group by city
order by total_revenue desc
limit 1;

# 10 Which product line incurred the highest gross income?
select product_line, sum(gross_income) as total_gross_income
from amazon
group by product_line
order by total_gross_income desc;

# 11  For each product line, add a column indicating "Good" if its sales are above average, otherwise "Bad."
select product_line, sum(total) as total_sales, avg(total) as avg_sales,
   case
       when sum(total)>(select avg(total) from amazon) then "Good"
    else "Bad"
END as sales_performance
from amazon 
group by product_line
order by total_sales desc;


# 12 Identify the branch that exceeded the average number of products sold.
with BranchWiseTotalSales as (
select branch,count(invoice_id) as total_products_sold from amazon
group by branch),
AverageProducts as(
select avg(total_products_sold) as avg_products_sold from BranchWiseTotalSales
)
select bt.branch, bt.total_products_sold, ap.avg_products_sold from BranchWiseTotalSales as bt, AverageProducts as ap
where bt.total_products_sold > ap.avg_products_sold;

# 13 Which product line is most frequently associated with each gender?
select Gender, product_line, count(*) as frequency from amazon
group by gender, product_line
order by gender, frequency desc;

# 14 Calculate the average rating for each product line.
select product_line, round(avg(rating),2) as avg_rating
 from amazon
 group by product_line
 order by avg_rating desc;
 
--  # 15 Count the sales occurrences for each time of day on every weekday.
select day_name,timeofday,count(*)no_of_sales
from amazon
group by day_name,timeofday
order by day_name,field(timeofday,'Morning','Afternoon','Evening');

# 16 Identify the customer type contributing the highest revenue
select customer_type, round(sum(cogs),2) as total_revenue
 from amazon
 group by customer_type
 order by total_revenue desc
 limit 1;
 
 # 17 Determine the city with the highest VAT percentage
select city, sum(vat) as highest_vat
from amazon
group by city
order by highest_vat desc
limit 1;

# 18 Identify the customer type with the highest VAT payments.
select customer_type,sum(vat) as total_vat
from amazon
group by customer_type
order by total_vat desc
limit 1;

# 19 What is the count of distinct customer types in the dataset?
select count(distinct customer_type) as No_of_Customers_types
from amazon;

# 20 What is the count of distinct payment methods in the dataset?
select count(distinct payment) as No_of_Payment_methods
from amazon;

# 21 Which customer type occurs most frequently?
select customer_type, count(*) as frequency
from amazon
group by customer_type
order by frequency desc
limit 1;

# 22 Identify the customer type with the highest purchase frequency.
select customer_type, sum(total) as Total_purchase
from amazon
group by customer_type
order by Total_purchase desc
limit 1;

# 23 Determine the predominant gender among customers.
select  gender, count(*) as No_Of_Customers
from amazon
group by gender
order by No_of_Customers Desc
limit 1;

# 24 Examine the distribution of genders within each branch.
select Branch,gender,count(*) as No_Of_Customers
from amazon
group by Branch, gender
order by No_of_Customers Desc;

# 25 Identify the time of day when customers provide the most ratings.
select timeofday, count(rating) as no_of_rating
from amazon
group by timeofday
order by no_of_rating desc
limit 1;

# 26 Determine the time of day with the highest customer ratings for each branch.
select branch,timeofday,no_of_rating
from(
select branch,timeofday,count(rating)as no_of_rating,
dense_rank() over(partition by branch order by count(rating)desc) as rn
from amazon
group by branch,timeofday)x1
where rn=1;

# 27 Identify the day of the week with the highest average ratings.

select day_name,round(avg(rating),3)as avg_rating
from amazon
group by day_name
order by avg_rating desc
limit 1;

# 28 Determine the day of the week with the highest average ratings for each branch.
select branch,day_name,avg_rating
from
(select branch,day_name,round(avg(rating),3)as avg_rating,
dense_rank() over(partition by branch order by round(avg(rating),3)desc) as rn
from amazon
group by branch,day_name)x1
where rn=1;