# RetailPulse

RetailPulse is a relational database project built with MySQL for exploring retail transactions and generating actionable business insights.

The project models a small retail operation where customers purchase products through different stores and sales employees. Transaction-level data is analyzed to understand revenue, customer spending, product profitability, store performance, and product returns.

---

## Project Overview

Retail businesses collect large amounts of transactional information every day. However, raw transaction records are not very useful until they are organized and analyzed.

RetailPulse converts retail transaction data into structured information that can be used to answer questions such as:

- Which products contribute the most revenue?
- Which customers generate the highest sales value?
- Which stores perform better than others?
- What payment methods are most frequently used?
- Which products have a high return percentage?
- How does sales revenue change over time?
- Which employees generate the highest sales?
- Which products provide better profit margins?

The main objective of this project is to demonstrate how SQL can be used to transform relational data into meaningful business insights.

---

## Technology Used

| Technology | Purpose |
|------------|---------|
| MySQL 8.0+ | Database management |
| SQL | Data creation, manipulation and analysis |
| MySQL Workbench | Database development and query execution |
| Git | Version control |
| GitHub | Project hosting |

---

## Database Structure

RetailPulse uses a normalized relational database.

The main entities are:

```text
Customers
    │
    │
    ▼
  Orders ─────────── Stores
    │
    │
    ▼
Order Items ─────── Products ───── Categories
    │
    ▼
 Returns

Employees
    │
    └── Manager hierarchy
```


### Project Organisation
```

RetailPulse-SQL/
│
├── README.md
│
├── schema/
│   └── 01_create_database.sql
│
├── data/
│   └── 02_insert_data.sql
│
├── queries/
│   ├── 03_basic_analysis.sql
│   ├── 04_joins.sql
│   ├── 05_subqueries.sql
│   └── 06_advanced_sql.sql
│
├── analysis/
    └── 07_business_analysis.sql


```
---

# SQL Skills Demonstrated

The project covers SQL concepts ranging from fundamental queries to advanced analytical operations.

## 🗄️ Database Design

- Database creation
- Table creation
- Primary keys
- Foreign keys
- Unique constraints
- Check constraints
- Referential integrity
- Database normalization

## 🔎 Data Retrieval

- `SELECT`
- `DISTINCT`
- `WHERE`
- `ORDER BY`
- `LIMIT`
- `BETWEEN`
- `IN`
- `LIKE`
- `IS NULL`

## 📊 Data Aggregation

- `COUNT()`
- `SUM()`
- `AVG()`
- `MIN()`
- `MAX()`
- `GROUP BY`
- `HAVING`

## 🧠 Conditional Logic

- `CASE`
- `COALESCE()`
- `NULLIF()`

## 🔗 Table Relationships

- `INNER JOIN`
- `LEFT JOIN`
- `SELF JOIN`

## 🚀 Advanced SQL

- Subqueries
- Common Table Expressions (CTEs)
- Window Functions
- Views
- Stored Procedures
- Indexes
  
---

### Setup

```sql

⚙️ Setup Instructions
Requirements
MySQL 8.0+
MySQL Workbench recommended
Step 1 — Create the database
Run: SOURCE schema/01_create_database.sql;
Step 2 — Insert sample data
Run: SOURCE data/02_insert_data.sql;
Step 3 — Run basic queries
SOURCE queries/03_basic_analysis.sql;
Step 4 — Run JOIN queries
SOURCE queries/04_joins.sql;
Step 5 — Run subqueries
SOURCE queries/05_subqueries.sql;
Step 6 — Run advanced SQL
SOURCE queries/06_advanced_sql.sql;
Step 7 — Run business analysis
SOURCE analysis/07_business_analysis.sql;

```

**Compatible with:** MySQL 8.0+

---

## 🎯 Learning Objectives

This project was developed to build practical experience in relational databases and SQL-based business analysis.

The key learning objectives include:

1. Understanding relational database design
2. Writing efficient SQL queries
3. Working with relationships between multiple tables
4. Performing data aggregation and analysis
5. Applying advanced SQL techniques to business problems
6. Understanding basic query optimization
7. Converting transactional data into business insights
8. Maintaining data integrity using database constraints

---

## 🚀 Possible Extensions

RetailPulse can be further expanded into a more comprehensive retail analytics platform.

Potential future improvements include:

- 📦 Inventory and stock-level tracking
- 🚚 Supplier and procurement management
- 👥 Customer churn analysis
- 📈 Sales forecasting
- 🎯 Product recommendation system
- 💰 Discount and promotion effectiveness analysis
- 🌎 Regional and city-level sales comparison
- 📊 Interactive Power BI dashboard
- 🔄 Automated ETL and data-loading pipeline
- ⚡ Query performance analysis and optimization
- 📋 Customer segmentation and RFM analysis
- 🛒 Shopping basket and product association analysis
- 📅 Seasonal sales trend analysis
- 🔔 Low-stock and high-return product alerts
  
---
