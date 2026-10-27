# Business Insights – E-Commerce Sales Analytics
## 1. Project Objective : 
Analyze customer behavior, sales performance, product profitability, order status, and payment performance using SQL Server.
## 2. Key Business Questions :
- Who are the highest-value customers?

| Customer_ID | First_Name | Last_Name | City          | State           | Total_Orders | Highest_Value  |
|-------------|------------|-----------|---------------|-----------------|--------------|----------------|
| 414         | Kiara      | Verma     | Lucknow       | Uttar Pradesh   | 18           | 1793311.126    |
| 106         | Riya       | Smith     | Delhi         | Delhi           | 14           | 1749799.158    |
| 317         | Vivaan     | Das       | Kochi         | Kerala          | 20           | 1740457.457    |
| 354         | Diya       | Johnson   | Bengaluru     | Karnataka       | 16           | 1652423.462    |
| 28          | Isha       | Miller    | Hyderabad     | Telangana       | 18           | 1626126.844    |
| 293         | William    | Roy       | Visakhapatnam | Andhra Pradesh  | 19           | 1616082.997    |
| 307         | Linda      | Roy       | Chandigarh    | Punjab          | 17           | 1600429.708    |
| 497         | Mia        | Verma     | Bhubaneswar   | Odisha          | 20           | 1598183.453    |
| 309         | Noah       | Johnson   | Chandigarh    | Punjab          | 15           | 1596829.449    |
| 371         | David      | Roy       | Mumbai        | Maharashtra     | 17           | 1591174.500    |

- Which products and categories generate the most revenue?
- How are sales changing month over month?
- What percentage of customers make repeat purchases?
- What percentage of payments fail?
- Which products have low stock?
- Which customers may be becoming inactive?
# 3. Key Findings
## Customer Analysis
- Top customers by total spending

| Customer_ID | First_Name | Last_Name | City          | State            | Total_Orders | Total_Spend   |
|-------------|------------|-----------|---------------|------------------|--------------|---------------|
| 414         | Kiara      | Verma     | Lucknow       | Uttar Pradesh    | 18           | 1793311.126   |
| 106         | Riya       | Smith     | Delhi         | Delhi            | 14           | 1749799.158   |
| 317         | Vivaan     | Das       | Kochi         | Kerala           | 20           | 1740457.457   |
| 354         | Diya       | Johnson   | Bengaluru     | Karnataka        | 16           | 1652423.462   |
| 28          | Isha       | Miller    | Hyderabad     | Telangana        | 18           | 1626126.844   |
| 293         | William    | Roy       | Visakhapatnam | Andhra Pradesh   | 19           | 1616082.997   |
| 307         | Linda      | Roy       | Chandigarh    | Punjab           | 17           | 1600429.708   |
| 497         | Mia        | Verma     | Bhubaneswar   | Odisha           | 20           | 1598183.453   |
| 309         | Noah       | Johnson   | Chandigarh    | Punjab           | 15           | 1596829.449   |
| 371         | David      | Roy       | Mumbai        | Maharashtra      | 17           | 1591174.500   |
| 311         | Ishaan     | Brown     | Bhopal        | Madhya Pradesh   | 15           | 1554837.418   |
| 435         | Ava        | Patel     | Visakhapatnam | Andhra Pradesh   | 16           | 1528138.042   |
| 192         | Aarav      | Iyer      | Hyderabad     | Telangana        | 21           | 1506839.289   |
| 440         | Sai        | Miller    | Bhopal        | Madhya Pradesh   | 14           | 1503576.211   |
| 321         | Ava        | Sharma    | Coimbatore    | Tamil Nadu       | 15           | 1473386.642   |
| 217         | Ayaan      | Jones     | Ahmedabad     | Gujarat          | 13           | 1468259.002   |
| 395         | Amelia     | Roy       | Bhubaneswar   | Odisha           | 15           | 1459480.131   |
| 376         | Jennifer   | Singh     | Mumbai        | Maharashtra      | 14           | 1442889.698   |
| 242         | Emma       | Anderson  | Bengaluru     | Karnataka        | 14           | 1417229.887   |
| 409         | David      | Johnson   | Mumbai        | Maharashtra      | 12           | 1398860.518   |

- Repeat customer percentage
- Highest-value customer segment
## Sales Analysis
- Total sales revenue
- Best-performing month
- Highest-revenue category
## Product Analysis

