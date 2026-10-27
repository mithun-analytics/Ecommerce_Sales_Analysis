-- ==========================================================
-- PROJECT: E-Commerce Sales Analysis
-- PURPOSE: Joins tables
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
-- 1. Orders with customer names
SELECT c.Customer_ID, c.First_Name,c.Last_Name,o.Order_ID, o.Order_Date,o.Order_Status
FROM Customers AS c
INNER JOIN Orders AS o ON c.Customer_ID=o.Order_ID
-- 2. Order items with product names and category
SELECT o.Order_ID,p.Product_Name,ca.Category_Name,o.Quantity,o.Unit_Price
FROM Products AS p
INNER JOIN Category AS ca ON p.Category_ID=ca.Category_ID
INNER JOIN Order_Items AS o ON o.Product_ID=p.Product_ID
-- 3. Full order detail: customer + product + category
SELECT c.Customer_ID,c.First_Name,c.Last_Name,od.Order_Date,p.Product_Name,o.Quantity,o.Unit_Price,ca.Category_Name
FROM Products p
INNER JOIN Category ca ON ca.Category_ID=p.Category_ID
INNER JOIN Order_Items o  ON o.Product_ID=p.Product_ID
INNER JOIN Orders od ON od.Order_ID=o.Order_ID
INNER JOIN Customers c ON c.Customer_ID=od.Customer_ID
-- 4. Customers who have never placed an order (LEFT JOIN + NULL check)
SELECT  c.Customer_ID,c.First_Name,c.Last_Name
FROM Customers c
LEFT JOIN Orders o ON c.Customer_ID=o.Customer_ID
WHERE o.Order_ID IS NULL
-- 5. Products that have never been ordered (LEFT JOIN + NULL check)
SELECT p.Product_ID,p.Product_Name
FROM Products p
LEFT JOIN Order_Items oi ON oi.Product_ID=p.Product_ID
WHERE oi.Order_ID IS NULL
-- 6. Orders that have no matching payment record (data quality check)
SELECT od.Order_ID,od.Order_Date,p.Payment_ID
from Orders od
LEFT JOIN Payments p ON p.Order_ID=od.Order_ID
WHERE p.Payment_ID IS NULL
-- 7. RIGHT JOIN example: every category, even those without products
SELECT p.Product_Name,c.Category_Name
FROM Products p
RIGHT JOIN Category c ON c.Category_ID=p.Category_ID
-- 8. UNION JOIN
SELECT c.Customer_ID,o.Order_ID
FROM Customers c
LEFT JOIN Orders o ON c.Customer_ID=o.Customer_ID
UNION
SELECT c.Customer_ID,o.Order_ID
FROM Customers c
RIGHT JOIN Orders o ON c.Customer_ID=o.Customer_ID
-- 9. SELF JOIN: customers who share the same city (potential regional clusters)
SELECT TOP 50 c.First_Name AS C_A,d.Last_Name AS C_B,c.City
FROM Customers c
JOIN Customers d ON c.City=d.City
ORDER BY c.Age
-- 10. Category-wise revenue join
SELECT c.Category_Name,
CAST(SUM(oi.Quantity * oi.Unit_Price*(1 - oi.Discount/100)) AS DECIMAL (10,2)) AS Revenue
FROM Category c 
JOIN Products p ON c.Category_ID=p.Category_ID
JOIN Order_Items oi ON p.Product_ID=oi.Product_ID
GROUP BY c.Category_Name
ORDER BY SUM(oi.Quantity * oi.Unit_Price)
-- 11. Customers with their total number of orders (LEFT JOIN + aggregate)
SELECT c.Customer_ID,c.First_Name,
COUNT(o.Order_ID) AS 'Total Number of Order'
FROM Customers c
LEFT JOIN Orders o ON c.Customer_ID=o.Customer_ID
GROUP BY c.Customer_ID,
 c.First_Name
ORDER BY COUNT(o.Order_ID)
-- 12. Products joined with category and brand, filtered to Electronics
SELECT p.Product_Name,p.Brand,c.Category_Name,p.Selling_Price
FROM Products p
JOIN Category c ON c.Category_ID=p.Category_ID
WHERE c.Category_Name='Electronics'
ORDER BY p.Selling_Price DESC
-- 13. Orders with payment method and shipping cost, only successful payments
SELECT od.Order_ID,od.Order_Date,od.Shipping_Cost,p.Payment_Method,p.Payment_Status
FROM Orders od
JOIN Payments p ON od.Order_ID=p.Order_ID
WHERE p.Payment_Status='Success'
-- 14. 15. Multi-table join: which customers bought from which categories
SELECT DISTINCT c.Customer_ID,c.First_Name,ca.Category_Name
FROM Customers c
JOIN Orders o ON c.Customer_ID=o.Order_ID
JOIN Order_Items ot ON ot.Order_ID=o.Order_ID
JOIN Products p ON p.Product_ID=ot.Product_ID
JOIN Category ca ON ca.Category_ID=p.Category_ID
ORDER BY c.Customer_ID