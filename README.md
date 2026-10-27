# E-Commerce Sales Analytics | SQL Portfolio Project

## Project Overview

This project analyzes an e-commerce retailer's sales data using **Microsoft SQL Server** to answer real-world business questions related to sales performance, customer behavior, product profitability, payment performance, and repeat purchases.

The objective is to demonstrate practical SQL skills and business analysis techniques that a Data Analyst would use to transform raw transactional data into actionable business insights.

## Business Objectives

- Identify high-value customers and repeat buyers.
- Analyze sales trends and monthly revenue growth.
- Identify top-performing products and categories.
- Evaluate customer purchasing behavior using RFM segmentation.
- Analyze order statuses and payment success rates.
- Identify potential customer churn and retention opportunities.
- Prepare data for market basket analysis.

## Tools & Technologies

- **Database:** Microsoft SQL Server
- **Querying:** T-SQL
- **IDE:** SQL Server Management Studio (SSMS)
- **Data Sources:** CSV files
- **Version Control:** Git and GitHub

## Database Schema

The project contains six relational tables representing customers, products, orders, order items, categories, and payments.

| Table | Expected Rows | Purpose |
|---|---:|---|
| Customers | 500 | Customer demographic and registration information |
| Categories | 8 | Product category information |
| Products | 240 | Product pricing, cost, category, and stock |
| Orders | 5,000 | Order dates, customers, and order statuses |
| Order_Items | Approximately 15,000 | Products, quantities, unit prices, and discounts per order |
| Payments | 5,000 | Payment methods, statuses, and amounts |


### Table Relationships

- `Customers.Customer_ID` → `Orders.Customer_ID`
- `Orders.Order_ID` → `Order_Items.Order_ID`
- `Products.Product_ID` → `Order_Items.Product_ID`
- `Categories.Category_ID` → `Products.Category_ID`
- `Orders.Order_ID` → `Payments.Order_ID`

The design uses primary keys and foreign keys to connect customer, order, product, category, and payment information.

## Project Structure

```text
Ecommerce_SQL_Portfolio/
│
├── README.md
│
├── Dataset/
│   ├── Customers.csv
│   ├── Categories.csv
│   ├── Products.csv
│   ├── Orders.csv
│   ├── Order_Items.csv
│   └── Payments.csv
│
├── SQL/
│   ├── 01_Create_Database.sql
│   ├── 02_Basic_SQL.sql
│   ├── 03_Joins.sql
│   ├── 04_Aggregations.sql
│   ├── 05_Subqueries.sql
│   ├── 06_CTEs.sql
│   ├── 07_Window_Functions.sql
│   ├── 08_Business_Case_Studies.sql
│   
│
└── Documentation/
    ├── Data_Dictionary.md
    ├── Database_Schema.png
    └── Business_Insights.md
```


## SQL Concepts Demonstrated

| SQL File | Topics Covered |
|---|---|
| 02_Basic_SQL.sql | SELECT, WHERE, ORDER BY, DISTINCT, TOP, LIKE, IN, BETWEEN |
| 03_Joins.sql | INNER JOIN, LEFT JOIN, RIGHT JOIN, FULL OUTER JOIN, SELF JOIN |
| 04_Aggregations.sql | COUNT, SUM, AVG, MIN, MAX, GROUP BY, HAVING |
| 05_Subqueries.sql | Nested and correlated subqueries, EXISTS, NOT EXISTS |
| 06_CTEs.sql | CTEs, multiple CTEs, recursive CTEs |
| 07_Window_Functions.sql | ROW_NUMBER, RANK, DENSE_RANK, LAG, LEAD, NTILE, CUME_DIST, window frames |
| 08_Business_Case_Studies.sql | Sales, customer, product, order, and payment analysis |


The project progresses from fundamental SQL queries to advanced querying techniques and business-oriented analysis.

## Business Case Studies

### 1. Customer Analytics

- Identify the top 20 customers by spending.
- Segment customers using Recency, Frequency, and Monetary (RFM) analysis.
- Identify one-time and repeat buyers.
- Analyze customer purchasing frequency and lifetime spending.
- Identify customers who may be at risk of becoming inactive.

**Business value:** Supports customer retention, loyalty programs, and targeted marketing campaigns.

### 2. Sales Performance Analysis

- Calculate total sales revenue and order counts.
- Analyze monthly and yearly sales trends.
- Calculate average order value (AOV).
- Compare sales performance across periods.
- Identify the highest-revenue products and categories.

**Business value:** Helps identify sales trends, growth opportunities, and high-performing product segments.

### 3. Product & Category Analysis

- Rank products by revenue and sales volume.
- Compare category-level performance.
- Calculate each product's contribution to total revenue.
- Perform ABC product analysis.
- Identify products with low sales or inventory concerns.

**Business value:** Helps prioritize products, improve assortment decisions, and support inventory planning.

### 4. Order Analysis

- Analyze order statuses and cancellation patterns.
- Compare order volume across months.
- Identify customers with repeated purchases.
- Examine order frequency and purchase intervals.

**Business value:** Helps identify operational issues and opportunities to improve the customer ordering experience.

### 5. Payment Analysis

- Calculate payment success and failure rates.
- Compare payment methods by transaction count and value.
- Identify payment trends and failure patterns.
- Compare order and payment records for inconsistencies.

**Business value:** Helps monitor payment performance and identify potential checkout friction.

### 6. Market Basket Analysis Preparation

- Identify products purchased together within the same order.
- Generate product-pair frequencies.
- Prepare data for association-rule metrics such as support, confidence, and lift.

**Business value:** Supports product bundling, cross-selling, and product recommendation strategies.

## Key Metrics

The project investigates the following business metrics:

| Metric | Definition |
|---|---|
| Total Orders | Number of distinct orders |
| Gross Item Value | Sum of quantity multiplied by unit price before discounts |
| Net Item Sales | Item value after discounts, based on the chosen revenue definition |
| Average Order Value | Defined order revenue divided by the relevant order count |
| Repeat Customer Rate | Customers with multiple qualifying purchases divided by qualifying customers |
| Payment Success Rate | Successful payment records divided by eligible payment records |
| Product Revenue Contribution | Product revenue divided by total qualifying product revenue |
| Customer Recency | Time elapsed since a customer's last qualifying purchase |

**Metric considerations:** Revenue calculations should consistently account for discounts, cancelled orders, refunds, and payment statuses where relevant. Product profitability should only be reported when the cost data and calculation assumptions are valid. Payment success rate should use a clearly defined transaction or order denominator.

## How to Run the Project

1. Install Microsoft SQL Server and SQL Server Management Studio.
2. Clone or download this repository.
3. Open `01_Create_Database.sql` in SSMS and execute the database creation and table setup statements.
4. Import the CSV files into their corresponding tables.
5. Verify data types, row counts, primary keys, foreign keys, and date formats.
6. Execute the SQL scripts in numerical order.
7. Review the query results and document validated business findings.

**SQL Server compatibility:** This project uses T-SQL. Use `TOP` or `OFFSET ... FETCH` for row limiting rather than MySQL's `LIMIT` syntax.

## Data Quality & Validation

Before interpreting the results, check:

- Missing values and duplicate records.
- Primary-key uniqueness and foreign-key integrity.
- Invalid dates, quantities, prices, discounts, and payment amounts.
- Whether each order has the expected payment relationship.
- Whether revenue totals reconcile across tables and queries.
- Whether cancelled orders, failed payments, and discounts are handled consistently.

## Key Findings & Recommendations

Document the actual results after running and validating the analysis.

Examples of findings to investigate:

- Which customers contribute the largest share of revenue?
- Which products or categories generate the most sales?
- Is revenue growing or declining over time?
- What proportion of customers make repeat purchases?
- Which payment methods have the highest failure rates?
- Which customer segments may benefit from retention campaigns?

Add quantified findings, supporting query outputs, and practical recommendations to `Documentation/Business_Insights.md`. Do not report hypothetical results as actual findings.

## Skills Demonstrated

- SQL querying and data manipulation
- Relational database design and joins
- Aggregation and business KPI calculations
- Subqueries and common table expressions
- Window functions and ranking
- Customer segmentation and RFM analysis
- Sales trend and product performance analysis
- Payment and order analysis
- SQL Server database objects and transaction concepts
- Data quality validation and business communication

## Conclusion

This project demonstrates how SQL can be used to investigate e-commerce business performance, understand customer purchasing behavior, analyze product and payment trends, and support data-driven decision-making.

It is part of my Data Analyst portfolio, showcasing practical SQL skills and the ability to translate business questions into structured analysis.

## Author

**Mithun Das**

Data Analyst Portfolio Project

[GitHub Profile](https://github.com/)

