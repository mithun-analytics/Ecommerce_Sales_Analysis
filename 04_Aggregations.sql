-- ==========================================================
-- PROJECT: E-Commerce Sales Analysis
-- PURPOSE: Aggregations
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
--1. Total revenue across all orders
SELECT CAST(SUM(Quantity*Unit_Price*(1-Discount/100)) AS DECIMAL(12,2)) AS 'Total Revenue'
FROM Order_Items
-- 2. Average order value
SELECT CAST(AVG(Total_Order) AS DECIMAL(18,2)) AS [Average Order Value] FROM
(SELECT Order_ID,SUM(Quantity*Unit_Price*(1-Discount/100)) AS Total_Order
FROM Order_Items
GROUP BY Order_ID) A
-- 3. Total number of orders per customer
SELECT Customer_ID, COUNT(*) AS Total_Orders
FROM Orders
GROUP BY Customer_ID
ORDER BY Customer_ID DESC
-- 4. Revenue by category
SELECT ca.Category_Name,SUM(oi.Quantity*oi.Unit_Price*(1-oi.Discount/100)) AS 'Revenue'
FROM Order_Items AS oi
JOIN Products as p ON p.Product_ID=oi.Product_ID
JOIN Category AS ca ON ca.Category_ID=p.Category_ID
GROUP BY ca.Category_Name
ORDER BY Revenue DESC
-- 5. Highest priced product per category
SELECT Category_ID, MAX(Selling_Price) AS Highest_Price
FROM Products
GROUP BY Category_ID;
-- 6. Lowest priced product per category
SELECT Category_ID, MIN(Selling_Price) AS Highest_Price
FROM Products
GROUP BY Category_ID 
ORDER BY Highest_Price ASC
-- 7. Number of products per category
SELECT c.Category_Name,COUNT(p.Category_ID) AS Product_Count
FROM Category c
LEFT JOIN Products p ON c.Category_ID=p.Category_ID
GROUP BY c.Category_Name,
p.Category_ID
-- 8. Customers with more than 15 orders (HAVING)
SELECT Customer_ID,COUNT(*) AS Oreder_Count
FROM Orders
GROUP BY Customer_ID
HAVING COUNT(*)>15
ORDER BY Customer_ID ASC
-- 9. Categories with average selling price above 10,000 (HAVING)
SELECT c.Category_Name,AVG(p.Selling_Price) AS AVG_Price
FROM Category c
JOIN Products p ON c.Category_ID=P.Category_ID
GROUP BY c.Category_Name
HAVING AVG(p.Selling_Price)>10000
-- 10. Monthly revenue trend
SELECT A.Month,CAST(A.Revenue AS DECIMAL(18,2)) AS Revenue FROM
(SELECT DATENAME(MONTH,o.Order_Date) AS "Month",MONTH(o.Order_Date) AS MONTH_NO,
SUM(oi.Quantity * oi.Unit_Price * (1 - oi.Discount/100)) AS Revenue
FROM Orders o
JOIN Order_Items oi ON o.Order_ID=oi.Order_ID
GROUP BY DATENAME(MONTH,o.Order_Date),
 MONTH(o.Order_Date)) A
 ORDER BY A.MONTH_NO ASC
 -- 11. Payment method usage count
 SELECT Payment_Method,COUNT(*) AS Time_Used
 FROM Payments
 GROUP BY Payment_Method
 ORDER BY Time_Used ASC
 -- 12. Revenue by payment method (successful payments only)
 SELECT Payment_Method,SUM(Amount) as Total_Revenue
 from Payments
 WHERE Payment_Status = 'Success'
 GROUP BY Payment_Method
 ORDER BY Total_Revenue DESC
 -- 13. Average age of customers by city
 SELECT City,AVG(Age) AS AVG_Age
 FROM Customers
 GROUP BY City
 ORDER BY AVG_Age DESC
 -- 14. Order status breakdown (counts and percentage)
 SELECT Order_Status,
       COUNT(*) AS Total,
       ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM Orders), 2) AS Pct_of_Orders
FROM Orders
GROUP BY Order_Status
ORDER BY Total DESC;
--
SELECT Order_Status,CAST(Order_Count * 100.0 /SUM(Order_Count) OVER() AS DECIMAL(5,2)) AS pct_count
FROM
(SELECT Order_Status, COUNT(*) AS Order_Count
FROM Orders
GROUP BY Order_Status) A
ORDER BY pct_count DESC
-- 15. Products with total quantity sold above 100 units (HAVING)
SELECT p.Product_Name,SUM(oi.Quantity) AS Total_QTY_Sold
FROM Products p
JOIN Order_Items oi ON p.Product_ID=oi.Product_ID
GROUP BY p.Product_Name
ORDER BY Total_QTY_Sold DESC
-- 16. Gross profit per product (Selling - Cost) * Qty sold
SELECT p.Product_Name,SUM(oi.Quantity* (p.Selling_Price - p.Cost_Price)) AS Gross_Profit
FROM Products p
JOIN Order_Items oi ON p.Product_ID=oi.Product_ID
GROUP BY p.Product_Name
ORDER BY Gross_Profit DESC
-- 17. State-wise revenue
SELECT c.State,CAST(SUM(oi.Quantity * oi.Unit_Price * (1-oi.Discount/100)) AS DECIMAL (18,2)) AS Revenue
FROM Customers c
JOIN Orders o ON c.Customer_ID=o.Customer_ID
JOIN Order_Items oi ON oi.Order_ID=o.Order_ID
GROUP BY c.State
ORDER BY Revenue DESC
-- 18. Average discount given per category
SELECT ct.Category_Name,CAST(AVG(oi.Discount) AS DECIMAL(5,2)) AS AVG_Discount
FROM Category ct
JOIN Products p ON ct.Category_ID=p.Category_ID
JOIN Order_Items oi ON oi.Product_ID=p.Product_ID
GROUP BY ct.Category_Name
ORDER BY AVG_Discount DESC
-- 19. Weekend vs weekday order counts
SELECT
    CASE 
        WHEN DATEPART(WEEKDAY, Order_Date) IN (1,7)
        THEN 'Weekend'
        ELSE 'Weekday'
    END AS Day_Type,
    COUNT(*) AS Total_Orders
FROM Orders
GROUP BY
    CASE 
        WHEN DATEPART(WEEKDAY, Order_Date) IN (1,7)
        THEN 'Weekend'
        ELSE 'Weekday'
    END;
-- 20. Cancelled and returned order value (potential lost revenue)
SELECT o.Order_Status, CAST(SUM(oi.Quantity * oi.Unit_Price * (1- oi.Discount/100)) AS DECIMAL(18,2)) AS Value_AT_Risk
FROM Orders o
JOIN Order_Items oi ON o.Order_ID=oi.Order_ID
WHERE Order_Status IN ('Cancelled','Returned')
GROUP BY o.Order_Status


