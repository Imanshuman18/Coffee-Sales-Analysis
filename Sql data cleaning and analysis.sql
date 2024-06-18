#Total Sales for specific month
Select * from coffee_sales;
Select ROUND(SUM(unit_price*transaction_qty),1) as Total_sales from coffee_sales where month(transaction_date)=5;
#mom sales growth
SELECT 
    MONTH(transaction_date) AS month,
    ROUND(SUM(unit_price * transaction_qty)) AS total_sales,
    (SUM(unit_price * transaction_qty) - LAG(SUM(unit_price * transaction_qty), 1)
    OVER (ORDER BY MONTH(transaction_date))) / LAG(SUM(unit_price * transaction_qty), 1) 
    OVER (ORDER BY MONTH(transaction_date)) * 100 AS mom_increase_percentage
FROM 
    coffee_sales
WHERE 
    MONTH(transaction_date) IN (4, 5) -- for months of April and May
GROUP BY 
    MONTH(transaction_date)
ORDER BY 
    MONTH(transaction_date);
-- Total Order
Select count(*) as Total_oders from coffee_sales where month(transaction_date)=3;
-- MOM DIFFERENCE AND MOM GROWTH
SELECT 
    MONTH(transaction_date) AS month,
    COUNT(transaction_id) AS total_orders,
    (COUNT(transaction_id) - LAG(COUNT(transaction_id), 1) 
    OVER (ORDER BY MONTH(transaction_date))) / LAG(COUNT(transaction_id), 1) 
    OVER (ORDER BY MONTH(transaction_date)) * 100 AS mom_increase_percentage
FROM 
    coffee_sales
WHERE 
    MONTH(transaction_date) IN (4, 5) -- for April and May
GROUP BY 
    MONTH(transaction_date)
ORDER BY 
    MONTH(transaction_date);
-- Total quantities sold
Select SUM(transaction_qty) from coffee_sales where MONTH(transaction_date)=5;    
--  MOM DIFFERENCE AND MOM GROWTH
SELECT 
    MONTH(transaction_date) AS month,
    sum(transaction_qty) AS total_qty,
    (sum(transaction_qty) - LAG(sum(transaction_qty), 1) 
    OVER (ORDER BY MONTH(transaction_date))) / LAG(sum(transaction_qty), 1) 
    OVER (ORDER BY MONTH(transaction_date)) * 100 AS mom_increase_percentage
FROM 
    coffee_sales
WHERE 
    MONTH(transaction_date) IN (4, 5) -- for April and May
GROUP BY 
    MONTH(transaction_date)
ORDER BY 
    MONTH(transaction_date);
-- Analysis for a day
Select Concat(SUM(transaction_qty)/1000,'K') as Total_qty,
Concat(Round(sum(unit_price*transaction_qty),1),'K') as Total_sales,
concat(Count(transaction_id)/1000,'K') as Total_orders from coffee_sales where transaction_date='2023-03-27';
-- Sales Analysis by weekdays and weekends
-- Weekdays-Mon to Fri
-- Weekends-Sat and Sun
SELECT 
CASE WHEN dayofweek(transaction_date) in (1,7) THEN 'Weekends'
else 'weekdays'
END as day_type,
Concat(Round(SUM(unit_price*transaction_qty)/1000,1),'K') as Total_sales
from coffee_sales
where MONTH(transaction_date)=5
Group by day_type;
-- Sales analysis by store location
Select concat(round(sum(unit_price*transaction_qty)/1000,1),'K')as total_sales ,store_location  from coffee_sales where month(transaction_date)=5 group by store_location;
-- monthly sales analysis for average 
Select concat(round(avg(total_sales)/1000,1),'K') as avg_sales
from (Select sum(unit_price*transaction_qty) as total_sales from coffee_sales where month(transaction_date)=5 group by transaction_date) as query;
-- Daily sales
SELECT DAY(transaction_date) as days,sum(unit_price*transaction_qty) as total_sales from coffee_sales
where month(transaction_date)=5
group by days
order by days;

-- COMPARING DAILY SALES WITH AVERAGE SALES – IF GREATER THAN “ABOVE AVERAGE” and LESSER THAN “BELOW AVERAGE”
SELECT 
    day_of_month,
    CASE 
        WHEN total_sales > avg_sales THEN 'Above Average'
        WHEN total_sales < avg_sales THEN 'Below Average'
        ELSE 'Average'
    END AS sales_status,
    total_sales
FROM (
    SELECT 
        DAY(transaction_date) AS day_of_month,
        SUM(unit_price * transaction_qty) AS total_sales,
        AVG(SUM(unit_price * transaction_qty)) OVER () AS avg_sales
    FROM 
        coffee_sales
    WHERE 
        MONTH(transaction_date) = 5  -- Filter for May
    GROUP BY 
        DAY(transaction_date)
) AS sales_data
ORDER BY 
    day_of_month;

-- Sales by product category
select * from coffee_sales;
Select sum(unit_price*transaction_qty) as total_sales,product_category from coffee_sales where month(transaction_date)=5 group by product_category order by total_sales desc;
-- Top 10 product by sales
Select SUM(unit_price*transaction_qty) as total_sales,product_type from coffee_sales where month(transaction_date)=5 group by product_type 
order by total_sales desc limit 10;
-- Sales by days and hours
Select Count(*) as total_order,
sum(unit_price*transaction_qty) as total_sales,
sum(transaction_qty) as total_qty
from coffee_sales
where month(transaction_date)=5 AND dayofweek(transaction_date)=2 And hour(transaction_time)=8;

