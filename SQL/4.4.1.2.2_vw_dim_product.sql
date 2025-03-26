--initial step for:
--.4 Saving Processed Data to SQL Server (Fact & Dimension Tables)
--• After cleaning and transforming the data, split it into a fact table and 3-4 dimension tables:
--o Dimension Tables:
--▪ Products: Product-related information.

CREATE view vw_dim_product as
SELECT
olist_products.[product_id]
,olist_products.[product_category_name]
,olist_products.[product_name_lenght]
,olist_products.[product_description_lenght]
,olist_products.[product_photos_qty]
,olist_products.[product_weight_g]
,olist_products.[product_length_cm]
,olist_products.[product_height_cm]
,olist_products.[product_width_cm]
,product_category_name_translation.[product_category_name_english]
FROM
[dbo].[olist_products] olist_products
INNER JOIN
[dbo].[product_category_name_translation] product_category_name_translation
on
olist_products.product_category_name = product_category_name_translation.product_category_name

