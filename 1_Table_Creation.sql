sp_databases
use ecommerce_portfolio
select * from sys.tables
select * from Category
select * from Customers
select * from Order_Items
select * from Orders
select * from Payments
select * from Products
-- ==========================================================
-- PROJECT: E-Commerce Sales Analysis
-- PURPOSE: End-to-end schema design and data import
-- AUTHOR: Mithun Das
-- ==========================================================
-- TABLE CREATION --
-- 1. Customers
CREATE TABLE Customers(
Customer_ID INT PRIMARY KEY,
First_Name VARCHAR(50) NOT NULL,
Last_Name VARCHAR(50) NOT NULL,
Gender VARCHAR(6) CHECK(Gender IN ('Male','Female')),
Age INT,
City VARCHAR(50),
State VARCHAR(50),
Join_Date DATE,
Email VARCHAR(50) UNIQUE
)
-- 2. Category
CREATE TABLE Category(
Category_ID INT PRIMARY KEY,
Category_Name VARCHAR(50)
)
-- 3. Products
CREATE TABLE Products(
Product_ID INT PRIMARY KEY,
Product_Name VARCHAR(50),
Category_ID INT,
Brand VARCHAR(50),
Cost_Price DECIMAL(10,2),
Selling_Price DECIMAL(10,2),
Stock INT,
FOREIGN KEY (Category_ID) REFERENCES Category(Category_ID)
)
-- 4. Orders
CREATE TABLE Orders(
Order_ID INT PRIMARY KEY,
Customer_ID INT,
Order_Date DATE,
Order_Status VARCHAR(50),
Shipping_Cost INT,
FOREIGN KEY (Customer_ID) REFERENCES Customers(Customer_ID)
)
-- 5. Order_Items
CREATE TABLE Order_Items(
Order_Item_ID INT PRIMARY KEY,
Order_ID INT,
Product_ID INT,
Quantity INT,
Unit_Price DECIMAL(10,2) NOT NULL,
Discount DECIMAL(5,2) DEFAULT 0,
FOREIGN KEY (Order_ID) REFERENCES Orders(Order_ID),
FOREIGN KEY (Product_ID) REFERENCES Products(Product_ID)
)
-- 6. Payments
CREATE TABLE Payments(
Payment_ID INT PRIMARY KEY,
Order_ID INT,
Payment_Method VARCHAR(50),
Amount DECIMAL(10,2),
FOREIGN KEY (Order_ID) REFERENCES Orders(Order_ID)
)
-- Insert data into created tables from existing imported raw csv file
insert into Payments
select * from Payments01
alter table Payments
add Payment_Status VARCHAR(50)