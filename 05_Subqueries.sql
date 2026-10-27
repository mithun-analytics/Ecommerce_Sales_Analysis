-- ==========================================================
-- PROJECT: E-Commerce Sales Analysis
-- PURPOSE: Subquries(Nested, Correlated, EXISTS, NOT EXISTS)
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
-- 1. Products priced above the overall average selling price
SELECT Product_Name,Selling_Price
FROM Products
WHERE Selling_Price > (SELECT AVG(Selling_Price) FROM Products)
-- 2. Customers who spent more than the average customer (nested subquery)
SELECT Customer_ID, Total_Spent
FROM (
    SELECT 
        o.Customer_ID,
        SUM(oi.Quantity * oi.Unit_Price * (1 - oi.Discount/100)) AS Total_Spent,
        AVG(SUM(oi.Quantity * oi.Unit_Price * (1 - oi.Discount/100))) 
            OVER() AS Avg_Spent
    FROM Orders o
    JOIN Order_Items oi 
        ON o.Order_ID = oi.Order_ID
    GROUP BY o.Customer_ID
) A
WHERE Total_Spent > Avg_Spent;
----------------------------------------------------------------------------------------------------
SELECT Customer_ID, Total_Spent FROM (
    SELECT o.Customer_ID, SUM(oi.Quantity * oi.Unit_Price * (1 - oi.Discount/100)) AS Total_Spent
    FROM Orders o
    JOIN Order_Items oi ON o.Order_ID = oi.Order_ID
    GROUP BY o.Customer_ID
) AS customer_spend
WHERE Total_Spent > (
    SELECT AVG(Total_Spent) FROM (
        SELECT o.Customer_ID, SUM(oi.Quantity * oi.Unit_Price * (1 - oi.Discount/100)) AS Total_Spent
        FROM Orders o
        JOIN Order_Items oi ON o.Order_ID = oi.Order_ID
        GROUP BY o.Customer_ID
    ) AS avg_calc
);
-- 3. Correlated subquery: each product's price vs its category average
SELECT p1.Product_Name, p1.Category_ID, p1.Selling_Price,
       (SELECT AVG(p2.Selling_Price) FROM Products p2 WHERE p2.Category_ID = p1.Category_ID) AS Category_Avg_Price
FROM Products p1
ORDER BY p1.Category_ID;
-- 4. Customers who have placed at least one order (EXISTS)
SELECT c.Customer_ID,c.First_Name,c.Last_Name
FROM Customers c
WHERE EXISTS (SELECT 1 FROM Orders o WHERE o.Customer_ID=C.Customer_ID)
-- 5. Customers who have never placed an order (NOT EXISTS)
SELECT c.Customer_ID,c.First_Name,c.Last_Name
FROM Customers c
WHERE NOT EXISTS (SELECT 1 FROM Orders o WHERE o.Customer_ID=C.Customer_ID)
-- 6. Products never ordered (NOT EXISTS version, more efficient than LEFT JOIN on large tables)
SELECT Product_ID,Product_Name
FROM Products p
WHERE NOT EXISTS (SELECT 1 FROM Order_Items oi WHERE oi.Product_ID=p.Product_ID)
-- 7. Orders where order value is above that customer's own average order value (correlated)
SELECT o.Order_ID, o.Customer_ID,
       (SELECT SUM(oi.Quantity * oi.Unit_Price * (1 - oi.Discount/100))
        FROM Order_Items oi WHERE oi.Order_ID = o.Order_ID) AS Order_Value
FROM Orders o
WHERE (SELECT SUM(oi.Quantity * oi.Unit_Price * (1 - oi.Discount/100))
       FROM Order_Items oi WHERE oi.Order_ID = o.Order_ID)
      > (
          SELECT AVG(order_total) FROM (
              SELECT oi2.Order_ID, SUM(oi2.Quantity * oi2.Unit_Price * (1 - oi2.Discount/100)) AS order_total
              FROM Order_Items oi2
              JOIN Orders o2 ON oi2.Order_ID = o2.Order_ID
              WHERE o2.Customer_ID = o.Customer_ID
              GROUP BY oi2.Order_ID
          ) t
      );
-- 8. Top category by revenue (subquery in FROM)
SELECT TOP 1 Category_Name, Revenue  FROM (
SELECT cat.Category_Name, CAST(SUM(oi.Quantity * oi.Unit_Price * (1-oi.Discount/100)) AS DECIMAL(18,2)) AS Revenue
FROM Order_Items oi
JOIN Products p     ON oi.Product_ID = p.Product_ID
    JOIN Category cat ON p.Category_ID = cat.Category_ID
    GROUP BY cat.Category_Name ) t
	ORDER BY Revenue DESC
-- 9. Customers whose most recent order was cancelled (correlated subquery)
SELECT  c.Customer_ID,c.First_Name,c.Last_Name
FROM Customers c
WHERE ( SELECT TOP 1 o.Order_Status FROM Orders o
WHERE o.Customer_ID=c.Customer_ID
ORDER BY o.Order_Date DESC)='Cancelled'
-- 10. Products priced above their brand's average price (correlated subquery)
SELECT p1.Product_Name, p1.Brand, p1.Selling_Price
FROM Products p1
WHERE p1.Selling_Price > (
    SELECT AVG(p2.Selling_Price) FROM Products p2 WHERE p2.Brand = p1.Brand
);
