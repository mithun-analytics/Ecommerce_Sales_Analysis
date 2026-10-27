-- ==========================================================
-- PROJECT: E-Commerce Sales Analysis
-- PURPOSE:ROW_NUMBER, RANK, DENSE_RANK, LEAD, LAG, FIRST_VALUE,LAST_VALUE, NTILE
-- AUTHOR: Mithun Das
-- ==========================================================
-- Database and Table Overview
SP_DATABASES
USE ecommerce_portfolio
SELECT * FROM SYS.tables
SELECT * FROM Customers
SELECT * FROM Category
SELECT * FROM Products
SELECT * FROM Orders
SELECT * FROM Order_Items
SELECT * FROM Payments
--1. Rank customers by lifetime value (RANK)
SELECT *,RANK() OVER (ORDER BY Life_Time_Value DESC) AS Value_Rank
FROM 
(SELECT 
	c.Customer_ID,c.First_Name,
	SUM(oi.Quantity * oi.Unit_Price * (1-oi.Discount/100)) AS Life_Time_Value
FROM Customers c
JOIN Orders o ON o.Customer_ID=c.Customer_ID
JOIN Order_Items oi ON oi.Order_ID=o.Order_ID
GROUP BY c.Customer_ID,c.First_Name)t
--2. Dense rank products by revenue within each category
SELECT *, DENSE_RANK() OVER (PARTITION BY Category_Name ORDER BY Revenue DESC) AS Rank_in_category
FROM
(SELECT p.Product_Name,ct.Category_Name,
	SUM(oi.Quantity * oi. Unit_Price * (1- oi.Discount/100)) AS Revenue
FROM Category ct
JOIN Products p ON p.Category_ID=ct.Category_ID
JOIN Order_Items oi ON oi.Product_ID=p.Product_ID
GROUP BY ct.Category_Name,p.Product_Name)t
-- 3. Top 3 products per category
SELECT * FROM
(SELECT *, DENSE_RANK() OVER (PARTITION BY Category_Name ORDER BY Revenue DESC) AS Rank_in_category
FROM
(SELECT p.Product_Name,ct.Category_Name,
	SUM(oi.Quantity * oi. Unit_Price * (1- oi.Discount/100)) AS Revenue
FROM Category ct
JOIN Products p ON p.Category_ID=ct.Category_ID
JOIN Order_Items oi ON oi.Product_ID=p.Product_ID
GROUP BY ct.Category_Name,p.Product_Name)t) a
WHERE Rank_in_category <=3
-- 4. Row number to remove duplicate customer emails (data cleaning use-case)
SELECT * FROM 
(SELECT *,  ROW_NUMBER() OVER (PARTITION BY Email ORDER BY Customer_ID) AS rn
FROM Customers) A
WHERE rn>1
-- 5. Running total of daily revenue
SELECT * , SUM(Revenue) OVER (ORDER BY Order_Date) AS Running_Total FROM
(SELECT o.Order_Date,SUM(oi.Quantity * oi.Unit_Price * (1-Discount/100)) AS Revenue
FROM Orders o
JOIN Order_Items oi ON o.Order_ID=oi.Order_ID
GROUP BY o.Order_Date) A
-- 6. Month-over-month revenue change (LAG)
SELECT Month_Name,Revenue,LAG(Revenue) OVER(ORDER BY Month_no)AS Prev_m_revenue,
Revenue-LAG(Revenue) OVER(ORDER BY Month_no) AS Change_revenue
FROM
(SELECT DATENAME(MONTH,o.Order_Date) AS Month_Name,MONTH(o.Order_Date) AS Month_no,
SUM(oi.Quantity*oi.Unit_Price*(1-Discount/100)) AS Revenue
FROM Orders o
JOIN Order_Items oi ON o.Order_ID=oi.Order_ID
GROUP BY DATENAME(MONTH,o.Order_Date),MONTH(o.Order_Date)) A
-- 7. Next order date per customer (LEAD) -- useful for churn/gap analysis
SELECT Customer_ID,Order_Date,LEAD(Order_Date) OVER (PARTITION BY Customer_ID ORDER BY Order_Date) AS Next_Order_Date
FROM Orders

SELECT Customer_ID, Order_Date,
       LEAD(Order_Date) OVER (PARTITION BY Customer_ID ORDER BY Order_Date) AS Next_Order_Date
FROM Orders;
-- 8. Days between consecutive orders per customer
SELECT 
    Customer_ID,
    Order_Date,
    DATEDIFF(
        DAY, 
        Order_Date, 
        LEAD(Order_Date) OVER (PARTITION BY Customer_ID ORDER BY Order_Date)
    ) AS Days_Until_Next_Order
FROM Orders;
-- 9. First and last order value per customer (FIRST_VALUE / LAST_VALUE)
SELECT DISTINCT Customer_ID,
       FIRST_VALUE(Order_ID) OVER (PARTITION BY Customer_ID ORDER BY Order_Date) AS First_Order,
       LAST_VALUE(Order_ID) OVER (PARTITION BY Customer_ID ORDER BY Order_Date
            ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS Last_Order
FROM Orders;
-- 10. Segment customers into quartiles by total spend (NTILE)
SELECT *,NTILE(4) OVER(ORDER BY Total_Spend DESC) AS Spend_Quartile
FROM
(SELECT o.Customer_ID,
	SUM(oi.Quantity * oi.Unit_Price * (1-oi.Discount/100)) AS Total_Spend
FROM Orders o
JOIN Order_Items oi ON o.Order_ID=oi.Order_ID
GROUP BY o.Customer_ID) A
-- 11. Percentage contribution of each product to total category revenue
SELECT *, CAST(ROUND(Revenue * 100.0/SUM(Revenue) OVER (PARTITION BY Category_ID),2) AS DECIMAL (5,2)) AS Pct_of_Category
FROM
(SELECT p.Category_ID, p.Product_Name,
           SUM(oi.Quantity * oi.Unit_Price * (1 - oi.Discount/100)) AS Revenue
    FROM Order_Items oi
    JOIN Products p ON oi.Product_ID = p.Product_ID
    GROUP BY p.Category_ID, p.Product_Name)A
-- 12. Customer order sequence number (identify 1st, 2nd, 3rd order etc.)
SELECT Customer_ID, Order_ID, Order_Date,
       ROW_NUMBER() OVER (PARTITION BY Customer_ID ORDER BY Order_Date) AS Order_Sequence
FROM Orders;
-- 13. Moving average of daily revenue (3-day window)
SELECT Order_Date, Daily_Revenue,
       AVG(Daily_Revenue) OVER (ORDER BY Order_Date ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) AS Moving_Avg_3Day
 FROM (SELECT o.Order_Date, SUM(oi.Quantity * oi.Unit_Price * (1 - oi.Discount/100)) AS Daily_Revenue
    FROM Orders o
    JOIN Order_Items oi ON o.Order_ID = oi.Order_ID
    GROUP BY o.Order_Date)t
-- 14. Rank cities by number of customers (RANK vs DENSE_RANK comparison)
SELECT City,Num_Customers,
	RANK() OVER(ORDER BY Num_Customers DESC) AS City_Rank,
	DENSE_RANK() OVER (ORDER BY Num_Customers DESC) AS City_Dense_Rank
	FROM
(SELECT City, COUNT(*) AS Num_Customers FROM Customers GROUP BY City) a
-- 15. Cumulative distribution of customers by lifetime value
SELECT Customer_ID, Lifetime_Value,
       ROUND(CUME_DIST() OVER (ORDER BY Lifetime_Value) * 100,2) AS Cume_Dist
FROM (
    SELECT o.Customer_ID,
           CAST(SUM(oi.Quantity * oi.Unit_Price * (1 - oi.Discount/100)) AS DECIMAL (10,2)) AS Lifetime_Value
    FROM Orders o
    JOIN Order_Items oi ON o.Order_ID = oi.Order_ID
    GROUP BY o.Customer_ID
) t;


