-- ==========================================================
-- PROJECT: E-Commerce Sales Analysis
-- PURPOSE: WITH clauses
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
-- 1. Order-level revenue via CTE, then filter to top orders
WITH Order_Revenue AS
(SELECT c.Customer_ID,o.Order_ID,
SUM(oi.Quantity*oi.Unit_Price*(1-oi.Discount/100)) AS Revenue
FROM Orders o
JOIN Order_Items oi ON o.Order_ID=oi.Order_ID
JOIN Customers c ON o.Customer_ID=c.Customer_ID
GROUP BY c.Customer_ID,o.Order_ID)
SELECT TOP 20 
Customer_ID,Order_ID,CAST(ROUND(Revenue, 2) AS DECIMAL(18,2)) AS Revenue
FROM Order_Revenue
ORDER BY Revenue DESC
-- 2. Customer lifetime value via CTE
WITH Customer_Revenue AS 
(SELECT o.Customer_ID,
SUM(oi.Quantity*oi.Unit_Price*(1-oi.Discount/100)) AS Lifetime_revenue
FROM Orders o
JOIN Order_Items oi ON o.Order_ID=oi.Order_ID
GROUP BY o.Customer_ID)
SELECT  TOP 20 c.Customer_ID,c.First_Name,c.Last_Name,CAST(ROUND(cr.Lifetime_revenue,2) AS DECIMAL(18,2)) AS Lifetime_revenue
FROM Customer_Revenue cr
JOIN Customers c ON c.Customer_ID=cr.Customer_ID
ORDER BY cr.Lifetime_revenue DESC
-- 3. Chained CTEs: category revenue -> rank categories -> filter top 3
WITH Category_Revenue AS (
    SELECT cat.Category_Name,
           SUM(oi.Quantity * oi.Unit_Price * (1 - oi.Discount/100)) AS Revenue
    FROM Order_Items oi
    JOIN Products p     ON oi.Product_ID = p.Product_ID
    JOIN Category cat ON p.Category_ID = cat.Category_ID
    GROUP BY cat.Category_Name
),
Ranked_Categories AS (
    SELECT *, RANK() OVER (ORDER BY Revenue DESC) AS Revenue_Rank
    FROM Category_Revenue
)
SELECT * FROM Ranked_Categories WHERE Revenue_Rank <= 3;
 -- 4. New vs repeat customers using CTE
 WITH Order_Counts AS
 (SELECT Customer_ID,COUNT(*) AS Total_Order
 FROM Orders
 GROUP BY Customer_ID)
 SELECT
	CASE WHEN Total_Order=1 THEN 'New_Customer' ELSE 'Repeat_Customer' END AS Customer_Type,
	COUNT(*) AS Num_Customers
	FROM Order_Counts
	GROUP BY 
	CASE 
        WHEN Total_Order = 1 THEN 'New_Customer' 
        ELSE 'Repeat_Customer' 
		END
-- 5. Monthly revenue with month-over-month comparison via CTE
WITH Monthly_Revenue AS
(
    SELECT 
        MONTH(o.Order_Date) AS Month_No,
        DATENAME(MONTH, o.Order_Date) AS Month_Name,
        CAST(ROUND(SUM(oi.Quantity * oi.Unit_Price * (1 - oi.Discount/100)), 2) AS DECIMAL(18,2)) AS Revenue
    FROM Orders o
    JOIN Order_Items oi ON oi.Order_ID = o.Order_ID
    GROUP BY 
        MONTH(o.Order_Date),
        DATENAME(MONTH, o.Order_Date)
)
SELECT 
    Month_Name,
    Revenue,
    CAST(ROUND(LAG(Revenue) OVER (ORDER BY Month_No), 2) AS DECIMAL(18,2)) AS Prev_Month_Revenue,
    CAST(ROUND(Revenue - LAG(Revenue) OVER (ORDER BY Month_No), 2) AS DECIMAL(18,2)) AS MoM_Change
FROM Monthly_Revenue
ORDER BY Month_No ASC
-- 6. Products with above-average profit margin, using CTE for margin calculation
WITH Profit_Margin AS
(SELECT Product_ID,Product_Name,
CAST(ROUND((Selling_Price-Cost_Price) / Selling_Price * 100,2) AS DECIMAL(10,2)) AS Margin
FROM Products)
SELECT * FROM Profit_Margin
WHERE Margin > (SELECT AVG(Margin) FROM Profit_Margin)
-- 7. RFM base metrics via CTE
WITH RFM_Base AS (
    SELECT o.Customer_ID,
           MAX(o.Order_Date) AS Last_Order_Date,
           COUNT(DISTINCT o.Order_ID) AS Frequency,
           SUM(oi.Quantity * oi.Unit_Price * (1 - Discount/100)) AS Monetary
    FROM Orders o
    JOIN Order_Items oi ON o.Order_ID = oi.Order_ID
    GROUP BY o.Customer_ID
)
SELECT *,
       DATEDIFF(DAY, Last_Order_Date, (SELECT MAX(Order_Date) FROM Orders)) AS Recency_Days
FROM RFM_Base
ORDER BY Monetary DESC;
-- 8. Payment success rate via CTE
WITH Payment_Summery AS
(SELECT Payment_Status, COUNT(*) AS Total
FROM Payments
GROUP BY Payment_Status)
SELECT *,ROUND(Total * 100.0/(SELECT SUM(Total) FROM Payment_Summery),2) AS Pct
FROM Payment_Summery
-- 9. Recursive CTE: generate a calendar of dates spanning the order history
-- First, get min and max dates
;WITH DateBounds AS (
    SELECT MIN(Order_Date) AS MinDate,
           MAX(Order_Date) AS MaxDate
    FROM Orders
),
Date_Range AS (
    -- Anchor member: start with MinDate
    SELECT MinDate AS Report_Date, MaxDate
    FROM DateBounds

    UNION ALL

    -- Recursive member: add 1 day until MaxDate
    SELECT DATEADD(DAY, 1, Report_Date), MaxDate
    FROM Date_Range
    WHERE Report_Date < MaxDate
)
SELECT Report_Date
FROM Date_Range
OPTION (MAXRECURSION 0);
--10 Top spender per state (CTE + window function combo)
WITH Customer_State_Spend AS
(SELECT c.Customer_ID,c.First_Name,c.Last_Name,c.State,
SUM(o.Quantity * o.Unit_Price * (1-o.Discount/100)) AS Total_Spend
FROM Customers c
JOIN Orders od ON od.Customer_ID=c.Customer_ID
JOIN Order_Items o ON o.Order_ID=od.Order_ID
GROUP BY c.Customer_ID,c.First_Name,c.State,c.Last_Name),
Ranked AS (
SELECT 
	Customer_ID,First_Name,Last_Name,State,Total_Spend,	
	ROW_NUMBER() OVER  (PARTITION BY State ORDER BY Total_Spend DESC) AS rn
	FROM Customer_State_Spend)
	SELECT * FROM Ranked
	WHERE rn=1;
