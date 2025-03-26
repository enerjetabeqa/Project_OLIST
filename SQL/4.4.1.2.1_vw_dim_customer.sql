--initial step for:
--.4 Saving Processed Data to SQL Server (Fact & Dimension Tables)
--• After cleaning and transforming the data, split it into a fact table and 3-4 dimension tables:
--o Dimension Tables:
--▪ Customers: Customer details including their geographic information.

CREATE view vw_dim_customer as
SELECT
olist_customers.[customer_id]
,olist_customers.[customer_unique_id]
,olist_customers.[customer_zip_code_prefix]
,olist_customers.[customer_city]
,olist_customers.[customer_state]
,olist_geolocation.[geolocation_zip_code_prefix]
,olist_geolocation.[geolocation_lat]
,olist_geolocation.[geolocation_lng]
,olist_geolocation.[geolocation_city]
,olist_geolocation.[geolocation_state]
FROM
[dbo].[olist_customers] olist_customers
INNER JOIN
[vw_olist_geolocation_unique] olist_geolocation
ON 
olist_customers.customer_zip_code_prefix = olist_geolocation.geolocation_zip_code_prefix;


