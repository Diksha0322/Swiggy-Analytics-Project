use swiggy_db;
select * from orders;

/* Swiggy over all sales dashboard */
CREATE VIEW vw_kpi_summary AS
select sum(total_amount) as total_revenue , count(orderid) as total_orders, avg(total_amount) as Average_order_value, avg(delivery_time_mins)
as average_delivery_time, (sum(if(status="Cancelled",1,0))/count(orderid))*100 as Order_cancellation_precentage from orders;

select * from vw_kpi_summary;

describe orders;
describe restaurant;

-- Location wise revenue and order cancellation %

create view vw_location_revenue_cancellation as
select r.location, sum(o.total_amount) as Total_revenue , (sum(if(status="Cancelled",1,0))/count(orderid))*100 as Order_cancellation_precentage from orders o left join restaurant r on o.restaurant_id= r.restaurantid
group by r.location
order by sum(o.total_amount) desc;

select * from vw_location_revenue_cancellation;

-- Month wise revenue and order volume
create view vw_monthwise_revenue_ordercount as
with CTE as 
( 
select month(order_date) as order_month, sum(total_amount) as total_revenue , count(orderid) as order_count
from orders 
group by month(order_date)
order by sum(total_amount) desc
)
select case
when order_month=1 then "January"
when order_month=2 then "February"
when order_month=3 then "March"
when order_month=4 then "April"
when order_month=5 then "May"
when order_month=6 then "June"
when order_month=7 then "July"
when order_month=8 then "August"
when order_month=9 then "September"
when order_month=10 then "October"
when order_month=11 then "November"
when order_month=12 then "December"
end as order_month_name,total_revenue, order_count
from CTE
order by total_revenue desc;

select * from vw_monthwise_revenue_ordercount;

/*    Customer Analytics dashboard metrics  */

/* Customer analytics KPI */
select  count(distinct(customer_id))  as "Total_Customers" from orders;

with CTE as
(select customer_id, count(orderid) as "order_count" from orders group by customer_id)
select (sum(if(order_count>1,1,0))/count(customer_id))*100 as "Repeat_cust%" from CTE;

with CTE as
(select customer_id, count(orderid) as "order_count" from orders group by customer_id)
select (sum(if(order_count=1,1,0))/count(customer_id))*100 as "Repeat_cust%" from CTE;

create view vw_month_wise_cust_cnt as
with CTE as 
( 
select month(order_date) as order_month, count(distinct(customer_id)) as "customer_count"
from orders 
group by month(order_date)
)
select case
when order_month=1 then "January"
when order_month=2 then "February"
when order_month=3 then "March"
when order_month=4 then "April"
when order_month=5 then "May"
when order_month=6 then "June"
when order_month=7 then "July"
when order_month=8 then "August"
when order_month=9 then "September"
when order_month=10 then "October"
when order_month=11 then "November"
when order_month=12 then "December"
end as order_month_name,customer_count
from CTE
order by customer_count desc;

select * from vw_month_wise_cust_cnt;

create view month_wise_new_repeat_cust_cnt as
(
with CTE as
(
select customer_id, monthname(order_date) as "Month_Name",count(orderid) as "order_count" from orders
group by customer_id,monthname(order_date)
)
select Month_Name,sum(if(order_count=1,1,0)) as "New_cust_count",sum(if(order_count>1,1,0))  as "Repeat_customer_count"
from CTE group by Month_name);

select * from month_wise_new_repeat_cust_cnt;

/* order and revenue analytics */

describe restaurant;
describe orders;

-- Revenuw by suisine type 

create view vw_cuisine_type_revenue as
select cuisine_type, sum(o.total_amount) as "Total Revenue" from orders o  join restaurant r on o.restaurant_id=r.restaurantid
group by cuisine_type
order by sum(total_amount) desc ;

Create view vw_restName_revenue as
(
with CTE as(
select substring(restaurant_name,1,locate('-',restaurant_name)-1) as "Restaurant_name", sum(total_amount) as "Total_Revenue" from orders o left join restaurant r on o.restaurant_id=r.restaurantid
group by restaurant_name
order by sum(total_amount)desc
)
select Restaurant_name , sum(Total_Revenue) from CTE group by Restaurant_name
order by sum(Total_Revenue) desc
);
select * from vw_restName_revenue;

create view vw_restaurant_cancellation_percentage as
(
SELECT 
SUBSTRING(restaurant_name,1,LOCATE('-',restaurant_name)-1) AS Restaurant_name,
(SUM(IF(status='cancelled',1,0)) / COUNT(o.orderid)) * 100 AS cancellation_percentage
FROM orders o
JOIN restaurant r 
ON o.restaurant_id = r.restaurantid
GROUP BY SUBSTRING(restaurant_name,1,LOCATE('-',restaurant_name)-1)
ORDER BY cancellation_percentage DESC
);
select * from vw_restaurant_cancellation_percentage;

create view vw_weekend_sales as 
(
select sum(Total_Revenue) as "weekend_sales" from
(
select dayname(order_date) as "Day_name" , sum(total_amount) as "Total_Revenue" from orders
group by dayname(order_date)
)a
where a.Day_name in ('Saturday','Sunday')
);

create view vw_weekday_sales as
select sum(Total_Revenue) as "weekend_sales" from
(
select dayname(order_date) as "Day_name" , sum(total_amount) as "Total_Revenue" from orders
group by dayname(order_date)
)a
where a.Day_name not in ('Saturday','Sunday');

select * from vw_weekday_sales;
select * from vw_weekend_sales;