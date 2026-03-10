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

Each file in this folder is a self‑contained query or set of queries against the gold layer, intended for exploration or reporting. They are numbered for a recommended execution order.

1. **`01-Database exploration.sql`** – introspect database objects and columns.
2. **`02-Dimensions Exploration.sql`** – list distinct values in customer countries and product categories.
3. **`03-Date Exploration.sql`** – identify date boundaries and customer age extremes.
4. **`04-Measure Exploration.sql`** – calculate business KPIs (total sales, orders, customers, etc.) and compile a metrics report.
5. **`05-Magnitude Analsyis.sql`** – aggregate measures by dimensions (country, gender, category, customer) to see distribution and revenue contributions.
6. **`06-Ranking.sql`** – top/bottom N analyses for products, subcategories, and customers using both `TOP` and window functions.
7. **`07-change over time.sql`** – trend analysis, aggregating sales and other metrics by year or formatted month.
8. **`08- commulative analsyis.sql`** – cumulative and running‑total computations with window functions.
9. **`09- performance analysis.sql`** – compare current sales against averages and prior year, with flags for performance categories.
10. **`10-part_to_whole_analysis.sql`** – part‑to‑whole breakdown (e.g. category’s share of total revenue).
11. **`11-Data segmentation.sql`** – segmentation logic for products (by cost) and customers (VIP/Regular/New) along with counts.
12. **`12- repot_customers.sql`** – view `gold.report_customers` offering detailed customer‑level metrics and KPIs including recency, average order value, segments, etc.
13. **`13- report_products.sql`** – view `gold.report_products` summarizing product‑level metrics, segments, recency, and revenue KPIs.

---

> **Note:** the analytics scripts generally assume the gold views already exist and have data. Copy or adapt them into reports, dashboards, or further ETL steps as required.

Feel free to reference this markdown when exploring or extending the project. Adjust descriptions as the code evolves.
