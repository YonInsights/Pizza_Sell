select *
from [Pizza DB]..pizza_sales
--Total revenu
select sum(total_price) As Total_revenu
from [Pizza DB]..pizza_sales
--Average order value
Select sum(total_price)/count(distinct(order_id)) As Average_order
from [Pizza DB]..pizza_sales
--Total Pizza sold 
Select COUNT(quantity) As Total_pizza_sold
from [Pizza DB]..pizza_sales
--Total order 
Select count(distinct(order_id)) As Total_order
from [Pizza DB]..pizza_sales

--Average pizza sell per order

SELECT 
    cast(CAST(SUM(quantity) AS decimal(10, 2)) / CAST(COUNT(DISTINCT order_id) AS decimal(10, 2)) as decimal (10,2)) As Average_pizza_per_order
FROM 
    [Pizza DB]..pizza_sales;


--Chart requirement
	--Hourly trend for total order
	Select DATEPART(hour,order_time) as order_hour,SUM(quantity) as total_sold 
	FROM 
    [Pizza DB]..pizza_sales
	Group by DATEPART(hour,order_time)
	order by order_hour
	--weekly trend for total order
	Select DATEPART(ISO_WEEK,order_date) as week_number, year(order_date) as order_Year ,count(distinct order_id)as total_orders
	FROM 
    [Pizza DB]..pizza_sales
	Group by DATEPART(ISO_WEEK,order_date) ,year(order_date)
	order by DATEPART(ISO_WEEK,order_date),year(order_date)  

	--percentage of pizza sell by catagory
	select pizza_category ,sum(total_price) as Total_price,SUM(total_price)*100/
	(select SUM(total_price) from pizza_sales	where MONTH(order_date)=1) As percentage_of_pizza_sell_by_catagory
	from pizza_sales
	where MONTH(order_date)=1
	Group by pizza_category
	--percentage of sells by pizza selles 

	SELECT 
    pizza_size,
    cast(SUM(total_price) as decimal (10,2)) AS Total_price,
    CAST(SUM(total_price) * 100.0 / (SELECT SUM(total_price) FROM pizza_sales where Datepart(quarter,order_date)=1) AS DECIMAL(10, 2)) AS percentage_of_pizza_sell_by_size
FROM 
    pizza_sales
where Datepart(quarter,order_date)=1
GROUP BY 
    pizza_size
ORDER BY 
    percentage_of_pizza_sell_by_size DESC;
	-- Top 5 best seller by revenu
	select Top 5 pizza_name, cast(sum(total_price) As decimal (10,2)) As Revenu_by_pizza_name
	From pizza_sales
	Group by pizza_name
	order by Revenu_by_pizza_name Desc
	-- Top 5 worest seller by revenu
	select Top 5 pizza_name, cast(sum(total_price) As decimal (10,2)) As Revenu_by_pizza_name
	From pizza_sales
	Group by pizza_name
	order by Revenu_by_pizza_name Asc
	-- Top 5 best seller by quantity
	select Top 5 pizza_name, COUNT(distinct(order_id)) As Total_orders
	From pizza_sales
	Group by pizza_name
	order by Total_orders Desc
		-- Top 5 worest seller by quantity
	select Top 5 pizza_name, COUNT(distinct(order_id)) As Total_orders
	From pizza_sales
	Group by pizza_name
	order by Total_orders Asc