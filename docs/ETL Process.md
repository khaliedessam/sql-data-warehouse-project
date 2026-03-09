## ⚙️ ETL Process

### ETL Pipeline Workflow

```
┌─────────────────────────────────────────┐
│       SOURCE SYSTEMS (CSV FILES)        │
│  ┌────────────┐      ┌────────────┐    │
│  │ CRM System │      │ ERP System │    │
│  │  (6 CSVs)  │      │  (3 CSVs)  │    │
│  └────────────┘      └────────────┘    │
└─────────────────────────────────────────┘
              ↓ (Extract)
┌─────────────────────────────────────────┐
│       STEP 1: BRONZE LAYER              │
│     ✓ Load raw data as-is               │
│     ✓ No transformations                │
│     ✓ Direct CSV import                 │
└─────────────────────────────────────────┘
              ↓ (Transform)
┌─────────────────────────────────────────┐
│       STEP 2: SILVER LAYER              │
│     ✓ Data quality checks               │
│     ✓ NULL value handling               │
│     ✓ Standardize formats               │
│     ✓ Remove duplicates                 │
│     ✓ Type conversions                  │
└─────────────────────────────────────────┘
              ↓ (Transform)
┌─────────────────────────────────────────┐
│       STEP 3: GOLD LAYER                │
│     ✓ Merge CRM + ERP data              │
│     ✓ Create surrogate keys             │
│     ✓ Generate star schema              │
│     ✓ Apply business rules              │
│     ✓ Optimize for analytics            │
└─────────────────────────────────────────┘
              ↓ (Load)
┌─────────────────────────────────────────┐
│   ANALYTICS & REPORTING LAYER           │
│  ✓ Dashboards                           │
│  ✓ Reports                              │
│  ✓ Business Intelligence                │
│  ✓ Machine Learning Models              │
└─────────────────────────────────────────┘
```

### Step-by-Step ETL Details

#### Step 1: Extract (Bronze Layer)
1. CSV files from CRM and ERP systems are imported directly
2. Data is loaded as-is with no transformations
3. Creates exact replica of source data in SQL Server database
4. Example: `CUST_INFO.csv` → `bronze.crm_cust_info`

#### Step 2: Transform - Cleanse (Silver Layer)
Applies standardization and quality rules:

| Transformation | Example | Business Value |
|---|---|---|
| **NULL Handling** | 'n/a' or empty strings → SQL NULL | Consistent representation |
| **Type Standardization** | All dates to DATE format | Query consistency |
| **String Trimming** | Remove leading/trailing spaces | Data accuracy |
| **Case Standardization** | Consistent UPPER/lower/Mixed case | Better analytics |
| **Deduplication** | Remove duplicate customer records | Single source of truth |
| **Default Values** | `dwh_create_date` = GETDATE() | Data lineage tracking |

**Deduplication Example**:
```sql
ROW_NUMBER() OVER (PARTITION BY customer_id, order_number 
                   ORDER BY load_date DESC) = 1
```
This keeps only the most recent version of duplicate records.

#### Step 3: Transform - Model (Gold Layer)
Creates business-level data structures:

1. **Dimension Tables** (Reference Data):
   - `dim_customers`: Unified customer master (CRM + ERP merged)
   - `dim_products`: Product master (consolidated catalog)
   - **Why**: Slow-changing reference data for consistent joins

2. **Fact Tables** (Transactional Data):
   - `fact_sales`: Sales transactions with foreign keys to dimensions
   - **Why**: Large volume of business events for analysis

3. **Surrogate Keys**:
   - Generated using `ROW_NUMBER()` OVER (ORDER BY natural_key)
   - Replaces natural keys (customer_id, product_id)
   - Benefits: Better join performance, hides source system changes

4. **Data Integration Rules**:
   ```
   Customer Dimension = CRM_CUST_INFO 
                        + ERP_CUST_AZ12 (birthdate, gender)
                        + ERP_LOC_A101 (country, location)
   
   Product Dimension = CRM_PRD_INFO 
                       + ERP_PX_CAT_G1V2 (category hierarchy)
   ```

---
