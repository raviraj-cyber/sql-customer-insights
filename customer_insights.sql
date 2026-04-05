------------------------------------------------------------------------
------------------------------------------------------------------------
-- Project :SQL -Based Customer Insights
-- Author: Ravi Raj
-- Tool: MySQL 8.0
-- Description: E-Commerce Customer Analysis using
                real-World SQL queries
-----------------------------------------------------------------------
-----------------------------------------------------------------------

USE customer_insights;

----------------------------------------------------------------------
 -- Query 1) TOTAL REVENUE BY CATEGORY
----------------------------------------------------------------------

SELECT p.category,
       sum(price*quantity) as total_revenue
FROM products as p
join order_items as oi ON p.product_id = oi.product_id                  
join orders as o ON o.order_id = oi.order_id
WHERE o.status ='Delivered'
GROUP BY p.category
ORDER BY total_revenue DESC;

----------------------------------------------------------------------
-- 2) TOP 5 CUSTOMERS BY SPENDING
----------------------------------------------------------------------

SELECT c.customer_id,
       customer_name,
       SUM(p.price*oi.quantity) as total_spent
FROM customers as c
JOIN orders AS o ON o.customer_id = c.customer_id                        
JOIN order_items AS oi ON oi.order_id = o.order_id
JOIN products as p ON p.product_id = oi.product_id
WHERE o.status = 'Delivered'
GROUP BY c.customer_id,c.customer_name
ORDER BY total_spent DESC
LIMIT 5;

----------------------------------------------------------------------
-- 3) MONTHLY REVENUE TREND
----------------------------------------------------------------------

SELECT DATE_FORMAT(o.order_date,'%y-%m') as month,
       SUM(p.price*oi.quantity) as total_revenue
FROM  orders  as o 
JOIN order_items as oi ON oi.order_id= o.order_id                      
JOIN products as p ON oi.product_id =p.product_id
WHERE o.status ='Delivered'
GROUP BY DATE_FORMAT(o.order_date,'%y-%m')
ORDER BY month ASC;

---------------------------------------------------------------------
 -- 4) CUSTOMER SEGMENTATION BY ORDER VOLUME
---------------------------------------------------------------------
SELECT c.customer_id,
       customer_name,
       COUNT(DISTINCT o.order_id) AS total_orders,
CASE 
    WHEN COUNT(DISTINCT o.order_id) >= 2 THEN 'Loyal'
    WHEN COUNT(DISTINCT o.order_id) = 1 THEN 'Occasional'
    ELSE 'One-Time'                                                  
END AS customer_segment
FROM customers as c
JOIN orders as o ON o.customer_id = c.customer_id
JOIN order_items as oi ON oi.order_id -o.order_id
WHERE o.status ='Delivered'
GROUP BY customer_id
ORDER BY total_orders;

----------------------------------------------------------------------
-- 5) REVENUE BY STATE
----------------------------------------------------------------------
SELECT COUNT(DISTINCT c.customer_id) AS customers,
       COUNT(DISTINCT o.Order_ID) AS orders,
       c.state,
       SUM(p.price*oi.quantity) as revenue
FROM customers as c
JOIN orders as o ON c.Customer_ID =o.Customer_ID       
JOIN order_items as oi ON o.Order_ID =oi.order_ID
JOIN products as p ON p.product_id =oi.product_id
WHERE o.status ='Delivered'
GROUP BY c.state
ORDER BY revenue DESC;

----------------------------------------------------------------------
 -- 6) CANCELLED ORDER ANALYSIS-(LOSSED REVENUE BY CANACELED ORDER)
----------------------------------------------------------------------

 SELECT c.state,
		COUNT(o.order_id) as canceled_orders,
		SUM(p.price*oi.quantity) as lost_revenue
 FROM customers AS c                                       
 JOIN orders AS o ON o.Customer_ID = c.customer_ID
 JOIN order_items AS oi ON oi.order_ID =o.Order_ID
 JOIN products AS p ON p.product_id = oi.product_id
 WHERE o.status ='Cancelled'
 GROUP BY state
 ORDER BY lost_revenue DESC;
 
 SELECT *from orders as o
 JOIN customers as c ON o.customer_id = c.Customer_ID
 WHERE status ='Cancelled';