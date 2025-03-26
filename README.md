# Project_OLIST

Documentation

### NOTEBOOKS

#### This solution is a full ETL pipeline written in Python using **Pandas** and **SQLAlchemy** to load the **Olist e-commerce dataset** (from CSV files) into a **SQL Server database**.

#### Breakdown of what's happening step by step:


### MAIN NOTEBOOK

## 🔧 **1. Imports and Environment Setup**
```python
import import_ipynb
from create_db_connection_strings import create_connection_string, create_sql_alchemy_engine
from read_env_file import SRVR, DTBS, USRNM, PSSWRD
from execute_sql import execute_sql_statement
```

- Loads custom modules:
  - **`create_db_connection_strings.py`**: for building the DB connection.
  - **`read_env_file.py`**: environment variables like server, database name, user, password.
  - **`execute_sql.py`**: used to run SQL commands like creating a DB.
- Uses **`os`** and **`pandas`** to navigate paths and load CSVs.

---

## 📁 **2. Load All CSVs from Directory**
```python
csv_path = "../OLIST_DATASET/"
all_csv = os.listdir(csv_path)
```

- E.g our dataset files are stored under `../OLIST_DATASET/`
- `all_csv` will be a list of all `.csv` filenames in that folder.

---

## 📊 **3. Definition of Functions for Reading and Creating DataFrames**

### A. Reads and drops duplicates:
```python
def pandas_read_unique_csv(base_csv_path: str, file: str):
    ...
```

### B. Creates a global variable for each CSV (e.g., `df_olist_orders_dataset`)
```python
def create_dataframes_programatically(variable: str,value: str,base_path: str):
    ...
```

- Dynamically creates variables like `df_olist_orders_dataset` using `globals()`.

---

## 🔁 **4. Create All DataFrames**
```python
for csv_file in all_csv:
    dtfrm = f"df_{csv_file.split('.')[0]}"
    create_dataframes_programatically(dtfrm,csv_file,csv_path)
```

- For every file, it creates a DataFrame and assigns it to a global variable.

---

## 👀 **5. Preview Loaded DataFrames**
```python
for csv_file in all_csv:
    ...
    print(globals()[var_name].head())
```

---

## 🛠️ **6. Create a Database and Engine**
```python
arg_conn = create_connection_string(SRVR,DTBS,USRNM,PSSWRD)
arg_eng = create_sql_alchemy_engine(arg_conn)

sql_stat = "CREATE DATABASE OLIST;"
rows = execute_sql_statement(arg_eng,sql_stat)
```

- Creates a new database called `OLIST` (if it doesn’t exist).
- Establishes a connection/engine to it.

---

## 🔗 **7. Connect to the New `OLIST` Database**
```python
arg_conn_olist = create_connection_string(SRVR,"OLIST",USRNM,PSSWRD)
arg_eng_olist = create_sql_alchemy_engine(arg_conn_olist)
```

---

## 💾 **8. Save DataFrames to SQL Tables**
### Examples:
```python
df_olist_customers_dataset.to_sql("olist_customers", con=arg_eng_olist, if_exists="replace", index=False)
```

- Saves each DataFrame to a table.
- `if_exists="replace"`: drops and recreates the table.

---

## 🛠️ **9. Transformations Before Inserting**

### A. `olist_orders`
```python
# Fill nulls and calculate delivery time
df_olist_orders_dataset['order_delivered_carrier_date'] = ...
df_olist_orders_dataset['delivery_time'] = ...
```

### B. `olist_order_payments`
```python
# Optional cleanup and add payment_count column
df_olist_order_payments_dataset = ...
```

### C. `olist_products`
```python
# Fill missing values
df_olist_products_dataset['product_category_name'].fillna('desconhecida', inplace=True)
```

### D. `product_category_name_translation`
```python
# Add custom category for unknown values
df_product_category_name_translation.loc[len(...)] = ['desconhecida', 'unknown']
```

---

## ✅ **Final Result**

- Every CSV file from the Olist dataset is:
  1. Read into a clean DataFrame
  2. Optionally transformed
  3. Inserted into the `OLIST` SQL database using `to_sql()`

---

## 🧠 In Summary

| Step | Description |
|------|-------------|
| 1 | Read env vars and setup |
| 2 | List and load CSVs |
| 3 | Create global variables for each DataFrame |
| 4 | Create the `OLIST` database |
| 5 | Transform data (optional) |
| 6 | Save each dataset as a table in the database |

---

### ADDITIONAL NOTEBOOKS

---

## 🧩 **1. `read_env_file.ipynb`**
This notebook loads **environment variables** from a `.env` file and exposes them as Python variables.

### ✅ What it does:
```python
from dotenv import load_dotenv
import os

load_dotenv()

SRVR = os.getenv("SRVR")
DTBS = os.getenv("DTBS")
USRNM = os.getenv("USRNM")
PSSWRD = os.getenv("PSSWRD")
```

These variables are used to define **database connection parameters** like:
- `SRVR` → my SQL Server instance (e.g., `"localhost"`)
- `DTBS` → initial database (e.g., `"master"`)
- `USRNM`, `PSSWRD` → credentials (e.g., `"olist_user"`, `"olist2025"`)

### 🔗 How it connects:
These are **imported in the main notebook** via:
```python
from read_env_file import SRVR, DTBS, USRNM, PSSWRD
```

This allows other modules (like connection builders) to use those values without hardcoding them.

---

## 🧩 **2. `create_db_connection_strings.ipynb`**
This notebook defines two functions that help **build and use the database connection** via SQLAlchemy and ODBC.

### ✅ Functions:

#### 🔹 `create_connection_string(...)`:
Creates a raw **ODBC connection string**:
```python
f'DRIVER={{ODBC Driver 17 for SQL Server}};SERVER={...};DATABASE={...};UID={...};PWD={...}'
```

#### 🔹 `create_sql_alchemy_engine(...)`:
Wraps that connection string into a **SQLAlchemy engine**:
```python
create_engine(f'mssql+pyodbc:///?odbc_connect={conn_str}')
```

### 🔗 How it connects:
Used in the main notebook:
```python
from create_db_connection_strings import create_connection_string, create_sql_alchemy_engine
...
arg_conn = create_connection_string(SRVR, DTBS, USRNM, PSSWRD)
arg_eng = create_sql_alchemy_engine(arg_conn)
```

Used to:
- Connect to the initial `master` DB to create `OLIST`.
- Then connect again to `OLIST` for loading tables.

---

## 🧩 **3. `execute_sql.ipynb`**
This notebook defines a utility function to **run raw SQL statements** (e.g., `CREATE DATABASE`).

### ✅ Function:

#### 🔹 `execute_sql_statement(engine, sql_statement)`:
- Connects using SQLAlchemy engine.
- Executes a SQL query.
- If it returns rows (e.g., `SELECT`), it prints them.
- If not (e.g., `INSERT`, `CREATE DATABASE`, etc.), it commits the transaction.

### 🔗 How it connects:
Used in the main notebook:
```python
from execute_sql import execute_sql_statement
...
sql_stat = "CREATE DATABASE OLIST;"
rows = execute_sql_statement(arg_eng, sql_stat)
```

This is the step where the **`OLIST` database is created programmatically** before any tables are loaded.

---

## 🔄 Overall Flow Recap

| File | Purpose | Used in Main Notebook |
|------|---------|------------------------|
| `read_env_file.ipynb` | Loads environment vars like server, user, password | ✅ Yes |
| `create_db_connection_strings.ipynb` | Builds connection string and engine | ✅ Yes |
| `execute_sql.ipynb` | Executes raw SQL like `CREATE DATABASE` | ✅ Yes |

---

## 🔗 Data Flow Diagram (Textual)

```text
.env --> read_env_file.ipynb --> SRVR, DTBS, USRNM, PSSWRD
                  ↓
     create_db_connection_strings.ipynb
                  ↓
       create_engine(...) --> SQLAlchemy Engine
                  ↓
       execute_sql.ipynb → execute_sql_statement() → CREATE DATABASE OLIST;
                  ↓
       main notebook reads CSVs and loads tables into OLIST
```

---


I am essentially building a **data pipeline and analysis environment** for the Olist dataset using:

- **Pandas and Python (ETL part)**
- **SQL (data modeling and querying)**
- **SQLAlchemy (to interact with the SQL Server database)**

---


SQL

### 🔁 **1. Data Cleaning & Transformation (Python & Pandas)**

I am loading raw CSVs into Pandas, cleaning them, creating calculated fields, and saving the cleaned data into SQL Server.

Key transformations:
- **`olist_products`**: Fill nulls, handle unknown categories.
- **`olist_orders`**: Fill missing delivery dates, create `delivery_time`.
- **`olist_order_items`**: Calculate `total_price` and `profit_margin`.
- **`olist_order_payments`**: Calculate `payment_count`.
- **Load everything to SQL Server using `to_sql`**

This creates raw tables like:
- `olist_orders`
- `olist_customers`
- `olist_order_items`
- `olist_order_payments`
- `olist_products`
- etc.

---

### 🧱 **2. SQL Views (Layered Data Modeling)**

Now that the cleaned data is in SQL Server, I define **views** for different purposes:

#### 🔹 `vw_total_sales_per_customer`
- Shows running total of sales per customer.
- Uses `SUM(payment_value)` with a window function.
- Joins `olist_order_payments` with `olist_orders`.

#### 🔹 `vw_average_delivery_time_per_product_category`
- Calculates delivery time and 7-day rolling average per product category.
- Joins orders, order items, and products.

#### 🔹 `vw_fact_order_items_payments`
- Combines order items and payment info into a **fact table-like structure**.
- Adds `total_price` and `profit_margin` fields from the earlier transformation.

#### 🔹 `vw_dim_customer`, `vw_dim_product`, `vw_dim_seller`, `vw_dim_date`
- These are my **dimension tables** for customer, product, seller, and time/date.
- They enrich the dataset using joins with things like geolocation or translations.

#### 🔹 `vw_olist_geolocation_unique`
- Filters geolocation data to get **unique entries per zip code**, ranked by lat/lng.

---

### 🧱 **3. Schemas & Materialization**

I materialize the views into actual tables in appropriate schemas (`dim` and `fact`) to support OLAP-style queries.

```sql
-- For example
SELECT * INTO dim.customer FROM vw_dim_customer;
SELECT * INTO fact.order_items_payments FROM vw_fact_order_items_payments;
```

These schemas organize my data warehouse-style model:
- `dim.customer`, `dim.product`, etc. → Dimensions
- `fact.order_items_payments` → Fact

---

### 📊 **4. Analytical Queries**

I then run analytical queries such as:

#### 🔸 Total sales per product category:
```sql
SELECT product_category_name_english, SUM(payment_value)
FROM fact.order_items_payments
JOIN dim.product ON ...
GROUP BY product_category_name_english;
```

#### 🔸 Average delivery time per seller:
Joins fact with `dim.date`, aggregates `DATEDIFF`.

#### 🔸 Number of orders per customer state:
Joins `dim.date` with `dim.customer`.

---

### 🔗 How Everything Connects

Here's a quick visual-style flow:

```
CSV files → pandas → data cleaning/transformation → SQL tables (olist_*) 
          ↓
   calculated columns: delivery_time, profit_margin, etc.
          ↓
     SQL views (vw_*) build logical model
          ↓
Materialize into schemas: dim.*, fact.*
          ↓
Run business queries on materialized data
```

---

