--initial step for:
--.4 Saving Processed Data to SQL Server (Fact & Dimension Tables)
--• After cleaning and transforming the data, split it into a fact table and 3-4 dimension tables:
--o Dimension Tables:
--▪ Date: Order Purchase Date and Delivery Date as a dimension for time

CREATE view vw_dim_date as
SELECT [order_id]
      ,[customer_id]
      ,[order_purchase_timestamp]
      ,[order_delivered_customer_date]
      ,[delivery_time]
  FROM [dbo].[olist_orders]


