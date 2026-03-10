# Scripts Folder Overview

This document provides a brief description of each SQL script located in the `scripts/` directory. It covers the bronze, silver, gold and analytics folders so you can quickly understand the purpose of each file.

---

## 🔧 Bronze Layer

| File | Purpose |
|------|---------|
| `init_database.sql` | Creates the `DataWarehouse` database and three schemas (`bronze`, `silver`, `gold`). Drops existing database if it exists. **Warning:** it wipes all data. |
| `Ddl Query for Bronze Layer.sql` | DDL definitions for the bronze tables. Drops and recreates raw staging tables for CRM and ERP source files. |
| `Stored Procedures for Bronze Layer.sql` | Contains a stored procedure `bronze.load_bronze` that truncates and bulk‑loads CSV files from `datasets/source_*` into the bronze tables. Timing and error reporting are included. |

---

## ⚙️ Silver Layer

| File | Purpose |
|------|---------|
| `Ddl Query for Silver Layer.sql` | DDL definitions for the silver tables; similar structure to bronze but adds a `dwh_create_date` column for lineage. |
| `Stored Procedures for Silver Layer.sql` | Stored procedure `silver.load_silver` that truncates silver tables and applies cleansing/transform logic to populate them from the bronze layer. Includes basic data quality rules, type conversions, and domain mappings. |

---

## 🌟 Gold Layer

| File | Purpose |
|------|---------|
| `Ddl gold layer.sql` | Defines the gold layer as **views** (virtual tables) rather than physical objects. Creates three views:
  - `gold.dim_customers` – customer dimension combining CRM/ERP and generating surrogate key
  - `gold.dim_products` – product dimension filtered and enriched with category info
  - `gold.fact_sales` – fact table integrating sales with the dimensional keys

Each view renames columns for business readability and performs the joins and filters needed for a star schema. |

---

## 📊 Analytics Folder

The `analytics` directory contains numbered SQL scripts that progressively explore and analyze the data exposed by the gold layer. Each file is designed to be run independently in a SQL client, and the numbering reflects a suggested workflow from simple exploration up to advanced reporting.

### 📁 File descriptions

| Filename | Purpose |
|----------|---------|
| `1-Database exploration.sql` | Metadata inspection: Explore all objects and columns in the database  |
| `2-Dimensions Exploration.sql` |  Identifying the unique values in each dimension (Customers and Products) (using DISTINCT)|
| `3-Date Exploration.sql` | Identifying Date boundaries to get time span of business  |
| `4-Measure Exploration.sql` | Generate a Report that shows all key metrics of the business KPIs such as  Total sales, total quantity, average price, total no. of products and customers . |
| `5-Magnitude Analsyis.sql` | Compare the measure values by categories to understand the importance of different categories such as total customers by countries or gender and  total products by category and so on . |
| `6-Ranking.sql` | Order the values of dimensions by measure in order to identify Top N performers & Bottom N performers so ranking analysis answers questions like What are the Top 10 products by sales? and so on . |
| `7-change over time.sql` | Change over time analsyis (Trends) such as Analyze Sale Performance  Over Time |
| `8- commulative analsyis.sql` | Aggregate the data progressivly over time to understand whether our business is growing or declining such as total sales per month and the running total of sales overtime.|
| `9- performance analysis.sql` | Comparing the current value to a targte value such as yearly performance of products comparing by the previous year's sales |
| `10-part_to_whole_analysis.sql` | Analyze how an individual part is performing compared to the overall. |
| `11-Data segmentation.sql` | To group data into meaningful categories for targeted insights For customer segmentation, product categorization, or regional analysis.. |
| `12- repot_customers.sql` | This report consolidates key customer metrics , behaviors and calulate valuable KPIs . |
| `13- report_products.sql` | This report consolidates key product metrics , behaviors and calulate valuable KPIs . |

---




> **Note:** the analytics scripts assume the gold views already exist and are populated. Use these files as examples or building blocks when creating dashboards, reports, or further analytical pipelines.

Feel free to reference this markdown when expanding the project or sharing documentation with team members.
 Adjust descriptions as the code evolves.
