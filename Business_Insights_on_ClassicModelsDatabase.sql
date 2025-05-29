use classicmodels;

## Fetch the employee number, first name and last name of those employees who are working as Sales Rep reporting to employee with employeenumber 1102 
select employeenumber,firstname,lastname from employees where jobtitle = "Sales Rep" and reportsto = 1102;


## Show the unique productline values containing the word cars at the end from the products table.
select distinct productline from products where productline like ("%cars");


## Using a CASE statement, segment customers into three categories based on their country
select customernumber,customername, case when country in ("USA","Canada") then "North America"
when country in ("UK","France","Germany") then "Europe" else "Others" end as CountrySegment from customers;


## Using the OrderDetails table, identify the top 10 products (by productCode) with the highest total order quantity across all orders 
select productcode, sum(quantityordered)Total_Ordered from orderdetails group by productcode order by Total_Ordered desc limit 10;


## Company wants to analyse payment frequency by month. Extract the month name from the payment date to count the total number of payments for each month 
## and include only those months with a payment count exceeding 20. Sort the results by total number of payments in descending order.  
select monthname(paymentdate)payment_month,count(amount)num_payments  from payments group by 1 having num_payments >20 order by 2 desc;


## List the top 5 countries (by order count) that Classic Models ships to.
select c.country,count(c.country)order_count from customers as c inner join orders as o on c.customernumber = o.customernumber group by 1 order by 2 desc limit 5;


## Create a view named product_category_sales that provides insights into sales performance by product category. 
create view product_category_sales as
select p.productline,sum(o.quantityordered * o.priceeach)Total_Sales,
count( distinct o.ordernumber)Number_of_Orders from products as p inner join orderdetails as o on p.productcode = o. productcode group by 1;


## Using customers and orders tables, rank the customers based on their order frequency
select c.customername,count(o.ordernumber)Order_count,dense_rank() over(order by count(o.ordernumber) desc)order_frequency_rnk
from customers as c inner join orders as o on c.customernumber = o.customernumber group by 1;


## Calculate year wise, month name wise count of orders and year over year (YoY) percentage change. Format the YoY values in no decimals and show in % sign.
select yr,month_name,total_orders,concat(round((total_orders-last_yr)/last_yr*100,0),"%") as `YOY% Change` from(
select year(orderdate)yr, monthname(orderdate)Month_name, count(ordernumber)Total_orders, 
lag(count(ordernumber)) over(order by year(orderdate))Last_yr from orders group by 1,2)a;


## Find out how many product lines are there for which the buy price value is greater than the average of buy price value. Show the output as product line and its count.
select productline, count(productline)Total from products where buyprice > (
select avg(buyprice)avg_price from products)group by 1 order by total desc;