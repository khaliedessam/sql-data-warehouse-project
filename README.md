# SQL Data Warehouse Project

## 📌 Project Overview
This project demonstrates the design and implementation of a modern Data Warehouse using SQL Server.  
The solution follows a multi-layer architecture: Bronze, Silver, and Gold layers.

---

## 🏗️ Architecture

The project follows the Medallion Architecture:

- **Bronze Layer** → Raw data ingestion
- **Silver Layer** → Data cleaning & transformation
- **Gold Layer** → Business-ready data model (Star Schema)

---

## 🗂️ Data Model

The Gold Layer contains:

- 2 Dimension Tables
- 1 Fact Table

### ⭐ Fact Table
- `fact_sales`

### 📊 Dimension Tables
- `dim_customer`
- `dim_product`

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
- T-SQL
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

## 📚 Data Catalogue

Detailed column-level documentation is available for:
- `dim_customer`
- `dim_product`
- `fact_sales`

---

## 🚀 How to Run the Project

1. Create Bronze schema
2. Run Silver layer stored procedures
3. Create Gold layer views/tables
4. Query the fact table for reporting

---

## 👤 Author
Khaled Essam  
SQL Data Engineer
