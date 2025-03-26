--4.3 Using Window Functions Over Partitions
--Average Delivery Time per Product Category: A rolling average of delivery time partitioned by product category

CREATE VIEW vw_average_delivery_time_per_product_category AS
SELECT 
    olist_products.product_category_name,
    
    -- Rolling average delivery time (in days)
    AVG(DATEDIFF(day, olist_orders.order_purchase_timestamp, olist_orders.order_delivered_customer_date)) 
        OVER (
            PARTITION BY olist_products.product_category_name 
            ORDER BY olist_orders.order_purchase_timestamp 
            ROWS BETWEEN 6 PRECEDING AND CURRENT ROW
        ) AS rolling_avg_delivery_time_7d

FROM [dbo].[olist_orders] olist_orders
INNER JOIN [dbo].[olist_order_items] olist_order_items
    ON olist_orders.order_id = olist_order_items.order_id
INNER JOIN [dbo].[olist_products] olist_products 
    ON olist_order_items.product_id = olist_products.product_id
WHERE olist_orders.order_status = 'delivered';
