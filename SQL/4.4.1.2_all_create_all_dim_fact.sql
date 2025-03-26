--Final steps for:
--4.4 Saving Processed Data to SQL Server (Fact & Dimension Tables)
--• After cleaning and transforming the data, split it into a fact table and 3-4 dimension tables:
--o Fact Table: Order Items with calculated columns (Total Price, Delivery Time, etc.).
--o Dimension Tables:
--▪ Customers: Customer details including their geographic information.
--▪ Products: Product-related information.
--▪ Sellers: Seller details including geographic data.
--▪ Date: Order Purchase Date and Delivery Date as a dimension for time.


------------------------------------------
create schema dim;
create schema fact;
------------------------------------------
SELECT *
INTO
dim.customer
FROM
vw_dim_customer;
------------------------------------------
SELECT *
INTO
dim.date
FROM
vw_dim_date;
------------------------------------------
SELECT *
INTO
dim.product
FROM
vw_dim_product;
------------------------------------------
SELECT *
INTO
dim.seller
FROM
vw_dim_seller;
------------------------------------------
SELECT *
INTO
fact.order_items_payments
FROM
vw_fact_order_items_payments;
------------------------------------------