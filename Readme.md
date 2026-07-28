# 🛒 E-Commerce Sales & Customer Analytics Dashboard

An end-to-end **Data Analytics project** built using **Python, MySQL, SQL, and Power BI** to analyze sales performance, customer behavior, product trends, and business KPIs from the Olist Brazilian E-Commerce dataset.

The project demonstrates a complete analytics workflow; from raw data exploration and database creation to SQL-based business analysis and interactive Power BI dashboards.

---

# 📌 Project Objectives

This project aims to answer key business questions such as:

- How is overall sales performance changing over time?
- Which products and categories generate the highest revenue?
- Who are the most valuable customers?
- Which payment methods are most commonly used?
- Which sellers contribute the most revenue?
- How can customers be segmented using RFM Analysis?
- What business insights can improve decision-making?

---

# 📊 Dashboard Preview

### Executive Overview

![Executive Dashboard](https://github.com/sarvesh-surve-2294/ecommerce-sales-customer-analytics/blob/main/images/Screenshot%202026-07-28%20011119.png)

### Sales Performance Analytics

![Customer Dashboard]((https://github.com/sarvesh-surve-2294/ecommerce-sales-customer-analytics/blob/main/images/Screenshot%202026-07-28%20011142.png))

### Customer & Delivery Analytics

![Product Dashboard](https://github.com/sarvesh-surve-2294/ecommerce-sales-customer-analytics/blob/main/images/Screenshot%202026-07-28%20011159.png)

### Product & Seller Analytics

![Business Dashboard]([images/rfm_business_insights.png](https://github.com/sarvesh-surve-2294/ecommerce-sales-customer-analytics/blob/main/images/Screenshot%202026-07-28%20011220.png))

---

# 🗂 Dataset

**Source:** Olist Brazilian E-Commerce Public Dataset

The dataset contains information about:

- Customers
- Orders
- Order Items
- Payments
- Reviews
- Products
- Sellers
- Geolocation
- Product Categories

---

# 🛠 Tech Stack

| Category | Technologies |
|-----------|--------------|
| Programming | Python (Pandas) |
| Database | MySQL |
| Query Language | SQL |
| Visualization | Power BI |
| IDE | VS Code |
| Version Control | Git & GitHub |

---

# 📂 Project Structure

```text
Ecommerce-Sales-Customer-Analytics
│
├── data/
├── docs/
├── images/
├── powerbi/
│   └── Ecommerce_Sales_Customer_Analytics.pbix
│
├── python/
│   ├── 01_data_understanding.ipynb
│   └── 03_load_data_to_mysql.ipynb
│
├── sql/
│   ├── 01_create_database.sql
│   ├── 02_create_tables.sql
│   ├── 03_import_data.md
│   ├── 04_constraints.sql
│   ├── 05_data_cleaning.sql
│   ├── 06_eda.sql
│   ├── 07_sales_analysis.sql
│   ├── 08_customer_analysis.sql
│   ├── 09_product_analysis.sql
│   ├── 10_rfm_analysis.sql
│   └── 11_business_insights.sql
│
├── README.md
└── requirements.txt
```

---

# 🔄 Project Workflow

```text
Raw CSV Files
        │
        ▼
Python
(Data Understanding & Validation)
        │
        ▼
MySQL
(Database Design & Data Storage)
        │
        ▼
SQL
(Data Cleaning + Business Analysis)
        │
        ▼
Power BI
(Interactive Dashboard & Storytelling)
```

---

# 📈 SQL Analysis

The project includes multiple SQL modules covering:

### Database Design
- Database creation
- Table creation
- Constraints
- Relationships

### Data Cleaning
- Missing values
- Duplicate validation
- Data quality checks

### Exploratory Data Analysis
- Customer overview
- Order overview
- Product overview
- Seller overview
- Payment methods
- Reviews

### Sales Analysis
- Revenue
- Orders
- Average Order Value
- Monthly trends
- Payment analysis
- State-wise revenue
- Freight analysis

### Customer Analysis
- Customer distribution
- Repeat customers
- Customer Lifetime Value
- Acquisition trend
- Highest spending customers

### Product Analysis
- Revenue by category
- Best-selling products
- Seller performance
- Product ratings
- Freight cost
- Product dimensions

### RFM Analysis
Customer segmentation into:

- Champions
- Loyal Customers
- Potential Loyalists
- Need Attention
- At Risk
- Others

### Business Insights
- Top customers
- Top sellers
- Revenue contribution
- Monthly growth
- Delivery performance
- Freight ratio
- Payment performance

---

# 📊 Power BI Dashboard

The dashboard consists of four interactive pages:

### 📌 Executive Overview
- Revenue KPIs
- Monthly Sales Trend
- Orders Trend
- Revenue by State
- Payment Method Distribution

### 👥 Customer Analytics
- Customer Distribution
- Customer Acquisition
- Top Customers
- Customer Segmentation

### 📦 Product Analytics
- Product Categories
- Top Sellers
- Revenue by Category
- Product Ratings
- Freight Analysis

### 🎯 RFM & Business Insights
- Customer Segments
- Revenue Contribution
- Monthly Growth
- Delivery Performance
- Business KPIs

---

# 💡 Key Insights

- Revenue trends reveal seasonal fluctuations across the year.
- Credit Card is the dominant payment method.
- A small percentage of customers contribute a significant share of revenue.
- Home & Furniture-related categories generate the highest sales.
- Customer segmentation identifies loyal customers and at-risk customers.
- Delivery delays and freight costs vary significantly across regions.
- Seller performance is concentrated among a relatively small group of sellers.

---

# ⭐ Skills Demonstrated

- Data Cleaning
- Exploratory Data Analysis
- SQL Query Optimization
- Relational Database Design
- Customer Segmentation (RFM)
- Business Intelligence
- Dashboard Design
- KPI Development
- Data Storytelling

---
