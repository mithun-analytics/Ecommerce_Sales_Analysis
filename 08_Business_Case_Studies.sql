-- ==========================================================
-- PROJECT: E-Commerce Sales Analysis
-- PURPOSE:Real-world business case studies
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
/*------------------------------------------------------------------------------
--1. Top 20 VIP Customers Business question: Who are our highest-value customers, 
and what should retention/loyalty programs prioritize?
--------------------------------------------------------------------------------*/
SELECT TOP 20 c.Customer_ID,c.First_Name,c.Last_Name,c.City,c.State,
COUNT(DISTINCT o.Order_ID) AS Total_Orders,
SUM(oi.Quantity * oi.Unit_Price * (1-Discount/100)) AS Life_time_value,
ROUND(SUM(oi.Quantity * oi.Unit_Price * (1-Discount/100)) / COUNT(DISTINCT o.Order_ID),2) AS AVG_Order_Value
FROM Customers c
JOIN Orders o ON c.Customer_ID=o.Customer_ID
JOIN Order_Items oi ON oi.Order_ID=o.Order_ID
GROUP BY c.Customer_ID,c.First_Name,c.Last_Name,c.City,c.State
ORDER BY Life_time_value DESC
/*---------------------------------------------------------
--2. Which products drive most of our revenue?,
(A = top 70% of revenue, B = next 20%, C = remaining 10%)
---------------------------------------------------------*/
WITH Product_Revenue AS (
    SELECT p.Product_ID, p.Product_Name,
           SUM(oi.Quantity * oi.Unit_Price * (1 - oi.Discount/100)) AS Revenue
    FROM Order_Items oi
    JOIN Products p ON oi.Product_ID = p.Product_ID
    GROUP BY p.Product_ID, p.Product_Name
),
Ranked AS (
    SELECT *,
           SUM(Revenue) OVER (ORDER BY Revenue DESC) AS Running_Revenue,
           SUM(Revenue) OVER () AS Total_Revenue
    FROM Product_Revenue
)
SELECT Product_ID, Product_Name, Revenue,
       CAST(ROUND(Running_Revenue * 100.0 / Total_Revenue, 2) AS DECIMAL (5,2)) AS Cumulative_Pct,
       CASE
           WHEN Running_Revenue * 100.0 / Total_Revenue <= 70 THEN 'A - Top Priority'
           WHEN Running_Revenue * 100.0 / Total_Revenue <= 90 THEN 'B - Medium Priority'
           ELSE 'C - Low Priority'
       END AS ABC_Segment
FROM Ranked
ORDER BY Revenue DESC;
/* ---------------------------------------------------------------------
   3. Segment customers for targeted
   marketing based on Recency, Frequency, and Monetary value?
   --------------------------------------------------------------------- */
WITH RFM AS (
    SELECT 
        o.Customer_ID,
        DATEDIFF(
            DAY, 
            MAX(o.Order_Date), 
            (SELECT MAX(Order_Date) FROM Orders)
        ) AS Recency,   -- days since last order
        COUNT(DISTINCT o.Order_ID) AS Frequency,
        SUM(oi.Quantity * oi.Unit_Price * (1 - oi.Discount/100)) AS Monetary
    FROM Orders o
    JOIN Order_Items oi 
        ON o.Order_ID = oi.Order_ID
    GROUP BY o.Customer_ID
),
RFM_Scored AS (
    SELECT *,
           NTILE(4) OVER (ORDER BY Recency ASC)    AS R_Score,   -- lower recency = better
           NTILE(4) OVER (ORDER BY Frequency DESC) AS F_Score,
           NTILE(4) OVER (ORDER BY Monetary DESC)  AS M_Score
    FROM RFM
)
SELECT 
    Customer_ID, 
    Recency, 
    Frequency, 
    Monetary, 
    R_Score, 
    F_Score, 
    M_Score,
    (R_Score + F_Score + M_Score) AS RFM_Total,
    CASE
        WHEN (R_Score + F_Score + M_Score) >= 10 THEN 'Champion'
        WHEN (R_Score + F_Score + M_Score) >= 7  THEN 'Loyal Customer'
        WHEN (R_Score + F_Score + M_Score) >= 4  THEN 'At Risk'
        ELSE 'Lost / Low Value'
    END AS Segment
FROM RFM_Scored
ORDER BY RFM_Total DESC;
/*----------------------------------------------------------------------------
--4. Repeat Purchase Analysis: What % of customers are repeat buyers, and how
   much more do they spend than one-time buyers?
------------------------------------------------------------------------------- */
WITH Customer_Orders AS 
(
    SELECT o.Customer_ID,
           COUNT(DISTINCT o.Order_ID) AS Total_Order,
           SUM(oi.Quantity * oi.Unit_Price * (1 - oi.Discount/100)) AS Total_Spent
    FROM Orders o
    JOIN Order_Items oi ON o.Order_ID = oi.Order_ID
    GROUP BY o.Customer_ID
),
Classified AS
(
    SELECT 
        Customer_ID,
        CASE 
            WHEN Total_Order = 1 THEN 'One Time Buyer'
            ELSE 'Repeat Buyer'
        END AS Customer_Type,
        Total_Spent
    FROM Customer_Orders
)
SELECT 
    Customer_Type,
    COUNT(*) AS Num_Customers,
    CAST(100.0 * COUNT(*) / SUM(COUNT(*)) OVER() AS DECIMAL(5,2)) AS Pct_Customers,
    CAST(AVG(Total_Spent) AS DECIMAL(15,2)) AS Avg_Spent
FROM Classified
GROUP BY Customer_Type;
/* ---------------------------------------------------------------------
   5. Market Basket Preparation Dataset
   Business question: Which products are frequently bought together?
   --------------------------------------------------------------------- */
SELECT a.Product_ID AS Product_A, pa.Product_Name AS Product_A_Name,
	b.Product_ID AS Product_B, pb.Product_Name AS Product_B_Name,
	COUNT(*) AS Times_Bought_Together
FROM Order_Items a
JOIN Order_Items b ON a.Order_ID=b.Order_ID AND a.Product_ID<b.Product_ID
JOIN Products pa ON a.Product_ID=pa.Product_ID
JOIN Products pb ON pa.Product_ID=pb.Product_ID
GROUP BY a.Product_ID, pa.Product_Name, b.Product_ID, pb.Product_Name
HAVING COUNT(*) > 3
ORDER BY Times_Bought_Together DESC
/* ---------------------------------------------------------------------
   6. Monthly Growth Analysis
   Business question: Is revenue growing month over month, and at
   what rate?
   --------------------------------------------------------------------- */
   SELECT *,CAST((Revenue-Prev_Month_Revenue) * 100 /NULLIF(Prev_Month_Revenue,0) AS DECIMAL(10,2)) AS PCT
   FROM
(SELECT Month_Name,Revenue,
LAG(Revenue) OVER(ORDER BY Month_No) AS Prev_Month_Revenue
FROM
(SELECT
DATENAME(MONTH,o.Order_Date) AS Month_Name,
MONTH(o.Order_Date) AS Month_No,
CAST(SUM(oi.Quantity * oi.Unit_Price * ( 1- oi.Discount/100)) AS DECIMAL(15,2)) AS Revenue
FROM Orders o 
JOIN Order_Items oi ON o.Order_ID=oi.Order_ID
GROUP BY DATENAME(MONTH,o.Order_Date),
MONTH(o.Order_Date)) A)B
/* ---------------------------------------------------------------------
 7. Customer Churn Detection
   Business question: Which previously active customers have gone
   quiet (no order in the last 90 days relative to their last order)?
   --------------------------------------------------------------------- */   
SELECT * 
FROM (
    SELECT 
        o.Customer_ID, 
        c.First_Name,
        c.Last_Name,
        MAX(o.Order_Date) AS Last_Order_Date, 
        COUNT(*) AS Total_Orders,
        DATEDIFF(
            DAY, 
            MAX(o.Order_Date), 
            (SELECT MAX(Order_Date) FROM Orders)
        ) AS Days_Since_Last_Order
    FROM Orders o
    JOIN Customers c 
        ON o.Customer_ID = c.Customer_ID
    GROUP BY o.Customer_ID, c.First_Name, c.Last_Name
) A
WHERE Total_Orders > 1 
  AND Days_Since_Last_Order >= 90   
ORDER BY Days_Since_Last_Order DESC;
