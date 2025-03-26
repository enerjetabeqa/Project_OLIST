--initial step for:
--.4 Saving Processed Data to SQL Server (Fact & Dimension Tables)
--• After cleaning and transforming the data, split it into a fact table and 3-4 dimension tables:
--o Dimension Tables:
--+ Sellers: Seller details including geographic data.


CREATE view vw_dim_seller as
SELECT 
[seller_id]
,[seller_zip_code_prefix]
,[seller_city]
,[seller_state]
,[geolocation_zip_code_prefix]
,[geolocation_lat]
,[geolocation_lng]
,[geolocation_city]
,[geolocation_state]
FROM 
[dbo].[olist_sellers] olist_sellers
INNER JOIN
[vw_olist_geolocation_unique] olist_geolocation
ON
olist_sellers.seller_zip_code_prefix = olist_geolocation.geolocation_zip_code_prefix


