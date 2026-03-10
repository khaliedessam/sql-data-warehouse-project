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

| # | Filename | Focus | Key outputs | Notes |
|---|----------|-------|-------------|-------|
| 1 | `Database exploration.sql` | Metadata inspection | Lists of tables & columns; peek at `dim_customers` | Useful to verify gold objects are available. |
| 2 | `Dimensions Exploration.sql` | Dimension value sets | Distinct countries; product categories / subcategories | Quick sanity checks on master data. |
| 3 | `Date Exploration.sql` | Date boundaries | First/last order date; customer age extremes | Establish temporal span of the business. |
| 4 | `Measure Exploration.sql` | Aggregate KPIs | Total sales, orders, customers, products; metrics report table | Foundation for executive summary dashboards. |
| 5 | `Magnitude Analsyis.sql` | Measure-by-dimension | Revenue/quantity customers by country/gender; category totals; customer revenue ranking | Helps prioritize focus areas. |
| 6 | `Ranking.sql` | Top/Bottom N analysis | Top‑5/10 products/customers; worst performers; ranked lists using window functions | Useful for leaderboard style reports. |
| 07 | `change over time.sql` | Trend analysis | Sales and customer counts by year or month | Time series for trend charts. |
| 08 | ` commulative analsyis.sql` | Cumulative & running totals | Yearly running totals, moving averages | Visualize growth over time. |
| 09 | ` performance analysis.sql` | Performance vs. benchmarks | Yearly product sales vs. average and prior year with change flags | Analytical help for variance reporting. |
| 10 | `part_to_whole_analysis.sql` | Part‑to‑whole ratio | Category share of overall revenue | Pie/donut chart inputs. |
| 11 | `Data segmentation.sql` | Segmentation | Product cost buckets; customer segments (VIP/Regular/New) and counts | Basis for targeted marketing or pricing. |
| 12 | ` repot_customers.sql` | Customer reporting view | View `gold.report_customers` with detailed metrics/KPIs per customer | Can be queried directly or used as source for downstream reports. |
| 13 | ` report_products.sql` | Product reporting view | View `gold.report_products` with product‑level KPIs and segments | Handy for product management dashboards. |

---



> **Note:** the analytics scripts assume the gold views already exist and are populated. Use these files as examples or building blocks when creating dashboards, reports, or further analytical pipelines.

Feel free to reference this markdown when expanding the project or sharing documentation with team members.
 Adjust descriptions as the code evolves.
