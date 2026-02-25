#  Data Warehouse and Analytics Project
welcome to the Data Warehouse and Analytics Project repository!
This project demonstrates a comprehensive data warehousing and analytics solution,from building
a data warehouse to generate actionable insights.Designed as a portfolio project, it highligts industry
best practices in data engineering and analytics.
---

## 📖 Project Overview
This project involves:

1. **Data Architecture**: Designing a Modern Data Warehouse Using Medallion Architecture **Bronze**, **Silver**, and **Gold** layers.
2. **ETL Pipelines**: Extracting, transforming, and loading data from source systems into the warehouse.
3. **Data Modeling**: Developing fact and dimension tables optimized for analytical queries.
4. **Analytics & Reporting**: Creating SQL-based reports and dashboards for actionable insights.
---

## 🚀 Project Requirements

### Building the Data Warehouse (Data Engineering)

#### Objective
Develop a modern data warehouse using SQL Server to consolidate sales data, enabling analytical reporting and informed decision-making.

#### Specifications
- **Data Sources**: Import data from two source systems (ERP and CRM) provided as CSV files.
- **Data Quality**: Cleanse and resolve data quality issues prior to analysis.
- **Integration**: Combine both sources into a single, user-friendly data model designed for analytical queries.
- **Scope**: Focus on the latest dataset only; historization of data is not required.
- **Documentation**: Provide clear documentation of the data model to support both business stakeholders and analytics teams.

---

## ⚙️ ETL Process

### 1️⃣ Bronze Layer
- Raw data loaded from source systems
- No transformations applied

### 2️⃣ Silver Layer
- Data cleansing
- Data standardization
- Handling NULL values
- Deduplication using `ROW_NUMBER()`

### 3️⃣ Gold Layer
- Star schema implementation
- Surrogate keys generated
- Business logic applied

---

## 🛠️ Technologies Used

- SQL Server
- Window Functions
- Git & GitHub

---

## 📈 Key Concepts Applied

- Data Warehousing
- Star Schema
- Dimension & Fact Modeling
- Data Transformation
- ETL Development
- Data Quality Checks

---


## 👤 Author
Khaled Essam  
SQL Data Engineer
