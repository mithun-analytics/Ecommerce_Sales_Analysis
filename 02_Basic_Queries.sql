-- ==========================================================
-- PROJECT: E-Commerce Sales Analysis
-- PURPOSE: Basic SQL
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
-- 1. List of all customers
SELECT * FROM Customers
-- 2. Count of Customers
SELECT COUNT(Customer_ID) AS 'Count of Customers'
FROM Customers
-- 3. List of all Products with their selling price
SELECT Product_Name,Selling_Price
FROM Products
-- 4. All Product list
SELECT Product_Name
FROM Products
GROUP BY Product_Name
-- 5. Count of Products by name
SELECT COUNT(*)
FROM
(SELECT Product_Name
FROM Products
GROUP BY Product_Name) AS P
-- 6. Get products priced above 5000
SELECT * FROM Products
WHERE Selling_Price > 5000
-- 7. Get the 10 most recent orders
SELECT TOP 10 * FROM Orders
ORDER BY Order_Date DESC 
-- 8. The 10 cheapest selling products
SELECT TOP 10 * FROM Products
ORDER BY Selling_Price ASC
 -- 9. The 10 highest selling products
 SELECT TOP 10 * FROM Products
ORDER BY Selling_Price DESC
-- 10. List distinct cities customers come from
SELECT City FROM Customers
GROUP BY City
-- 11. List distinct order statuses
SELECT Order_Status FROM Orders
GROUP BY Order_Status
-- 12. Find products whose name contains 'Shoes'
SELECT *
FROM Products
WHERE Product_Name LIKE '%Shoes%';
-- 13. Find customers whose first name starts with 'A'
SELECT * FROM Customers
WHERE First_Name LIKE '%A%'
-- 14. Orders with status Delivered or Shipped
SELECT * FROM Orders
WHERE Order_Status IN ('Delivered','Shipped')
-- 15. Customers aged between 25 and 35
SELECT * FROM Customers
WHERE Age BETWEEN 25 AND 35
-- 16. Products with stock between 0 and 10 (near out-of-stock)
SELECT * FROM Products
WHERE Stock BETWEEN 0 AND 10
-- 17. Orders placed in the year 2024
SELECT * FROM Orders
WHERE Order_Date BETWEEN '2024-01-01' AND '2024-12-31'
-- 18. Count total number of customers
SELECT COUNT(*) AS 'Total Customer' FROM Customers
-- 19. Count total number of products per brand
SELECT Brand, COUNT(*) AS 'Brand Count' FROM Products
GROUP BY Brand
ORDER BY [Brand Count]
-- 20. Find all Electronics category products (hardcoded id)
SELECT * FROM Products
WHERE Category_ID=1
-- 21. Orders with shipping cost equal to 0
SELECT * FROM Orders
WHERE Shipping_Cost=0
-- 22. Customers who joined in 2024
SELECT * FROM Customers
WHERE Join_Date BETWEEN '2024-01-01' AND '2024-12-31'
-- 23. Payments made via UPI
SELECT * FROM Payments
WHERE Payment_Method = 'UPI'
-- 24. Failed payments
SELECT * FROM Payments
WHERE Payment_Status = 'Failed'
-- 25. Top 5 most expensive products
SELECT TOP 5 * FROM Products
ORDER BY Cost_Price DESC
-- 26. Orders with shipping cost greater than 100
SELECT * FROM Orders
WHERE Shipping_Cost > 100
-- 27. Male customers younger than 30
SELECT * FROM
(SELECT * FROM Customers
WHERE Age < 30) AS A
WHERE Gender='Male'
-- 28. Products not in the Grocery category (id 4)
SELECT * FROM Products WHERE Category_ID <> 4

