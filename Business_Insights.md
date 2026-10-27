# Business Insights – E-Commerce Sales Analytics
## 1. Project Objective : 
Analyze customer behavior, sales performance, product profitability, order status, and payment performance using SQL Server.
## 2. Key Business Questions :
- Who are the highest-value customers?
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

| Customer_Type | Number of Customer | % of Customers | AVG Spent |
|-------------- |--------------------|----------------|-----------|
| Repeat Buyer  |         500        | 100            | 802977    |

- Highest-value customer segment

| Customer_Segment     | Total_Customers | Total_Revenue       | Average_Customer_Spend |
|----------------------|-----------------|---------------------|------------------------|
| Loyal Customers      | 108             | 97968935.0835       | 907119.769291666       |
| Potential Loyalists  | 145             | 92299941.3285       | 636551.319506896       |
| Champions            | 73              | 76073177.0435       | 1042098.315664383      |
| Lost Customers       | 113             | 55430945.4605       | 490539.340358407       |
| At Risk              | 26              | 17174936.7395       | 660574.489980769       |
| Regular Customers    | 35              | 16005901.3245       | 457311.466414285       |


## Sales Analysis
- Total sales revenue : 354953836.98
- Best-performing month : 

| Sales_Year | Sales_Month | Month_Name | Total_Sales_Revenue |
|------------|-------------|------------|---------------------|
| 2024       | 1           | January    | 12772027.903        |

- Highest-revenue category

| Category_Name | Total_Revenue |
|---------------|---------------|
| Fashion       | 65459059.17   |

## Product Analysis
- Top products by revenue:

| Product_ID | Product_Name          | Total_Units_Sold | Total_Revenue   |
|------------|-----------------------|------------------|-----------------|
| 117        | Primo Smartphone      | 188              | 4009345.095     |
| 94         | Aurelia Sports Cap    | 154              | 3990609.2505    |
| 210        | Zylo Gaming Keyboard  | 183              | 3950096.421     |
| 121        | MaxPro Beard Trimmer  | 161              | 3940057.360     |
| 178        | Solace Formal Shirt   | 145              | 3662188.5685    |
| 164        | Novara Body Lotion    | 160              | 3578921.145     |
| 191        | Solace LED Monitor    | 162              | 3560539.1155    |
| 109        | Novara Leather Wallet | 162              | 3524972.162     |
| 84         | EcoLife Cricket Bat   | 190              | 3511042.708     |
| 208        | Pulse Cookbook        | 156              | 3380105.988     |

- Most profitable products:

| Product_ID | Product_Name              | Total_Units_Sold | Total_Revenue   | Total_Cost    | Total_Profit    |
|------------|---------------------------|------------------|-----------------|---------------|-----------------|
| 117        | Primo Smartphone          | 188              | 4009345.095     | 2270071.80    | 1739273.295     |
| 94         | Aurelia Sports Cap        | 154              | 3990609.2505    | 2258651.78    | 1731957.4705    |
| 121        | MaxPro Beard Trimmer      | 161              | 3940057.360     | 2409674.12    | 1530383.240     |
| 178        | Solace Formal Shirt       | 145              | 3662188.5685    | 2143082.60    | 1519105.9685    |
| 163        | EcoLife Wall Clock        | 159              | 3323253.892     | 1890199.95    | 1433053.942     |
| 210        | Zylo Gaming Keyboard      | 183              | 3950096.421     | 2520744.48    | 1429351.941     |
| 208        | Pulse Cookbook            | 156              | 3380105.988     | 1993191.72    | 1386914.268     |
| 191        | Solace LED Monitor        | 162              | 3560539.1155    | 2188911.60    | 1371627.5155    |
| 221        | Bright Home Men's T-Shirt | 122              | 3181709.004     | 1828959.34    | 1352749.664     |
| 84         | EcoLife Cricket Bat       | 190              | 3511042.708     | 2206513.70    | 1304529.008     |

- Products requiring stock attention:

| Product_ID | Product_Name              | Stock | Stock_Status    |
|------------|---------------------------|-------|-----------------|
| 7          | EcoLife Wall Clock        | 2     | Critical Stock  |
| 74         | Nexova Wireless Mouse     | 8     | Critical Stock  |
| 96         | MaxPro Study Table        | 8     | Critical Stock  |
| 202        | MaxPro Webcam HD          | 10    | Critical Stock  |
| 208        | Pulse Cookbook            | 14    | Low Stock       |
| 144        | VistaCore Whole Wheat Atta| 17    | Low Stock       |
| 227        | Aurelia Resistance Bands  | 18    | Low Stock       |



# Payment Analysis
- Successful payment rate: 

| Total_Payments | Successful_Payments | Successful_Payment_Rate_Percent |
|----------------|---------------------|---------------------------------|
| 5000           | 3131                | 62.62                           |

- Failed payment rate:

| Total_Payments | Failed_Payments | Failed_Payment_Rate_Percent |
|----------------|-----------------|-----------------------------|
| 5000           | 585             | 11.70                       |

- Most frequently used payment method:

| Payment_Method | Total_Payments | Payment_Method_Percentage |
|----------------|----------------|---------------------------|
| Credit Card    | 890            | 17.80                     |

# 4. Business Recommendations
- Create loyalty offers for high-value customers.
- Investigate reasons for failed payments.
- Review inventory for low-stock, high-demand products.
- Use monthly sales trends to improve sales planning.
- Encourage repeat purchases through targeted campaigns.