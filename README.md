# Amazon_sales_Analysis


Objective-The major aim of this project is to gain insight into the sales data of Amazon to understand the different factors that affect sales of the different branches.


Approach Used
1. Data Wrangling: This is the first step where inspection of data is done to make sure NULL values and missing values are detected and data replacement methods are used to replace missing or NULL values.
1.1. Build a database
1.2. Create a table and insert the data.
1.3. Select columns with null values in them. There are no null values in our database as in creating the tables, we set NOT NULL for each field, hence null values are filtered out.

2. Feature Engineering: This will help us generate some new columns from existing ones.
2.1. Add a new column named timeofday to give insight of sales in the Morning, Afternoon and Evening. This will help answer the question on which part of the day most sales are made.
2.2. Add a new column named dayname that contains the extracted days of the week on which the given transaction took place (Mon, Tue, Wed, Thur, Fri). This will help answer the question on which week of the day each branch is busiest.
2.3. Add a new column named monthname that contains the extracted months of the year on which the given transaction took place (Jan, Feb, Mar). Help determine which month of the year has the most sales and profit.
3. Exploratory Data Analysis (EDA): Exploratory data analysis is done to answer the listed questions and aims of this project.

Business Questions To Answer:

1.	What is the count of distinct cities in the dataset?
SELECT COUNT(distinct City) AS DISTINCT_CITY_COUNT
FROM amazon;
![image](https://github.com/user-attachments/assets/6ea22790-2c35-44ac-988d-dd96c9605641)


 
 2. For each branch, what is the corresponding city?
select branch,city from amazon
group by branch,city
order by branch ;
 
4.	 What is the count of distinct product lines in the dataset?
select count(distinct Product_line) as distinct_product_line from amazon; 

5.	Which payment method occurs most frequently?
          select payment,count(*) as frequent_payment_method 
          from amazon
           group by payment
          order by payment desc
    limit 1;
 

6.	 Which product line has the highest sales?
select product_line, sum(total) as sales
from amazon
group by product_line
order by sales
limit 1;
 

7.	 How much revenue is generated each month?
select monthname(str_to_date(datee,"%d-%m-%y"))as month, sum(cogs) as total_cogs
from amazon
group by monthname(str_to_date(datee,"%d-%m-%y"));
 
8.	  In which month did the cost of goods sold reach its peak?
select monthname(str_to_date(datee,"%d-%m-%y"))as month, sum(cogs) as total_cogs
from amazon
group by monthname(str_to_date(datee,"%d-%m-%y"))
order by total_cogs desc
limit 1;
 





9.	 Which product line generated the highest revenue?
select product_line,sum(total) as total_revenue
from amazon
group by product_line
order by total_revenue desc
limit 1;
 

10.	 In which city was the highest revenue recorded?
select city,sum(total) as total_revenue
from amazon
group by city
order by total_revenue desc
limit 1;
 


11.	 Which product line incurred the highest gross income?
select product_line, sum(gross_income) as total_gross_income
from amazon
group by product_line
order by total_gross_income desc;
 



 12.  For each product line, add a column indicating "Good" if its sales are above average, otherwise "Bad."
select product_line, sum(total) as total_sales, avg(total) as avg_sales,
   case
       when sum(total)>(select avg(total) from amazon) then "Good"
    else "Bad"
END as sales_performance
from amazon 
group by product_line
order by total_sales desc;
 



13.	 Identify the branch that exceeded the average number of products sold.
with BranchWiseTotalSales as (
select branch,count(invoice_id) as total_products_sold from amazon
group by branch),
AverageProducts as(
select avg(total_products_sold) as avg_products_sold from BranchWiseTotalSales
)
select bt.branch, bt.total_products_sold, ap.avg_products_sold from BranchWiseTotalSales as bt, AverageProducts as ap
where bt.total_products_sold > ap.avg_products_sold;
 

 
14. Which product line is most frequently associated with each gender?
select Gender, product_line, count(*) as frequency from amazon
group by gender, product_line
order by gender, frequency desc;
 

15.	 Calculate the average rating for each product line.
select product_line, round(avg(rating),2) as avg_rating
 from amazon
 group by product_line
 order by avg_rating desc;
 
 
16.	 Count the sales occurrences for each time of day on every weekday.
select day_name,timeofday,count(*)no_of_sales
from amazon
group by day_name,timeofday
order by day_name,field(timeofday,'Morning','Afternoon','Evening');
 

17.	 Identify the customer type contributing the highest revenue
select customer_type, round(sum(cogs),2) as total_revenue
 from amazon
 group by customer_type
 order by total_revenue desc
 limit 1;
 
 
18.	 Determine the city with the highest VAT percentage
select city, sum(vat) as highest_vat
from amazon
group by city
order by highest_vat desc
limit 1;
 
19.	 Identify the customer type with the highest VAT payments.
select customer_type,sum(vat) as total_vat
from amazon
group by customer_type
order by total_vat desc
limit 1;
 

20.	 What is the count of distinct customer types in the dataset?
select count(distinct customer_type) as No_of_Customers_types
from amazon;
 
21.	 What is the count of distinct payment methods in the dataset?
select count(distinct payment) as No_of_Payment_methods
from amazon;
 

22.	 Which customer type occurs most frequently?
select customer_type, count(*) as frequency
from amazon
group by customer_type
order by frequency desc
limit 1;
 


23.	 Identify the customer type with the highest purchase frequency.
select customer_type, sum(total) as Total_purchase
from amazon
group by customer_type
order by Total_purchase desc
limit 1;
 
24.	 Determine the predominant gender among customers.
select  gender, count(*) as No_Of_Customers
from amazon
group by gender
order by No_of_Customers Desc
limit 1;
 

25.	 Examine the distribution of genders within each branch.
select Branch,gender,count(*) as No_Of_Customers
from amazon
group by Branch, gender
order by No_of_Customers Desc;
 



26.	 Identify the time of day when customers provide the most ratings.
select timeofday, count(rating) as no_of_rating
from amazon
group by timeofday
order by no_of_rating desc
limit 1;
 

26 . Determine the time of day with the highest customer ratings for each branch.
select branch,timeofday,no_of_rating
from(
select branch,timeofday,count(rating)as no_of_rating,
dense_rank() over(partition by branch order by count(rating)desc) as rn
from amazon
group by branch,timeofday)x1
where rn=1;
 

27.	 Identify the day of the week with the highest average ratings.
select day_name,round(avg(rating),3)as avg_rating
from amazon
group by day_name
order by avg_rating desc
limit 1;
 


28.	 Determine the day of the week with the highest average ratings for each branch.
select branch,day_name,avg_rating
from
(select branch,day_name,round(avg(rating),3)as avg_rating,
dense_rank() over(partition by branch order by round(avg(rating),3)desc) as rn
from amazon
group by branch,day_name)x1
where rn=1;
 






















	Product Analysis
•	Top-Performing Product Lines:
The "Food and beverages" product line generates the highest revenue $56144.84, contributing 174 to the overall sales. It also has the highest customer satisfaction rating of 7.1. This line should be prioritized for inventory restocking, marketing, and strategic expansion.
•	Underperforming Product Lines:
Low-performing product lines, such as "Health and beauty," require targeted marketing efforts, potential quality improvements, or discontinuation if they remain unprofitable despite intervention. Its contributing least, $49193.73, contributing 152 to the overall sales.
•	Customer Satisfaction:
High ratings indicate customer satisfaction. Focus on replicating the success of well-rated product lines across others.

	Sales Analysis:
•	Monthly Trends:
Peak revenue months, such as March and January, indicate high-demand periods (e.g., holidays). These months can benefit from additional stock, promotional offers, and strategic advertising. Conversely, low-revenue months like February require campaigns or discounts to stimulate sales.
•	Time of Day Trends:
Peak purchasing periods reveal when customers are most active, such as afternoons from 12 PM to 5 PM, contributing revenue $172468.55. Sales strategies should align with these times, offering incentives during high-traffic periods.
•	Branch Comparisons:
High-performing branches like "C" should serve as benchmarks. Its contributes highest revenue $110568.70. Investigate and address disparities.
•	Cost Analysis:
High COGS during 'January', aligns with increased sales activity. Contributes COGS 110754. Monitoring these trends ensures profitability while maintaining operational efficiency.

	Customer Analysis:
•	Customer Types:
"Members" contribute significantly to revenue, generating $164223.44 in total sales. They should be incentivized through loyalty programs or exclusive offers. Non-members generating $40,000 in revenue could be encouraged to join loyalty schemes.
•	Gender Insights:
Female customers dominate the customer base, making up 51% of total purchases. Focused marketing campaigns tailored to this demographic can increase engagement and sales. Efforts to attract male customers may expand the customer base.
•	Profitability Segments:
Members also contribute the Highest, 7820.16 TAX payments, indicating they purchase premium products. Special offers and programs for these segments can further drive sales and loyalty.
	Recommendations

1. For Product Line Improvement
•	Continue to invest in Food and Beverages, as it consistently shows strong performance.
•	Introduce new products in Food and Beverages product line.

2. For Sales Strategy
•	Naypyitaw consistently generates the highest revenue. Expand promotional activities in other cities.
•	The peak times for sales are in the Afternoon and Evening; therefore, optimize store operations and staffing during these hours.

3. For Customer Engagement
•	Female customers are doing more sales, increase promotional activities more focused on female customers.
•	Increase promotional activities to attract more customers to join as members.

