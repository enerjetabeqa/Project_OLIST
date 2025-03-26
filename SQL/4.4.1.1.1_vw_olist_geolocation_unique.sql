--prerequisite for:
--.4 Saving Processed Data to SQL Server (Fact & Dimension Tables)
--• After cleaning and transforming the data, split it into a fact table and 3-4 dimension tables:
--o Dimension Tables:

create view vw_olist_geolocation_unique
AS
SELECT
a.[geolocation_zip_code_prefix]
,a.[geolocation_lat]
,a.[geolocation_lng]
,a.[geolocation_city]
,a.[geolocation_state]
,a.rank_column
from
(SELECT
[geolocation_zip_code_prefix]
,[geolocation_lat]
,[geolocation_lng]
,[geolocation_city]
,[geolocation_state]
,RANK() OVER (PARTITION BY geolocation_zip_code_prefix ORDER BY geolocation_lat DESC,geolocation_lng DESC) AS rank_column
FROM [OLIST].[dbo].[olist_geolocation]) a
where a.rank_column = 1;


