--4.3 Using Window Functions Over Partitions
--o Total Sales per Customer: A running total of product price for each customer partitioned by Customer ID.

CREATE VIEW vw_total_sales_per_customer AS
SELECT
    olist_orders.customer_id,
    olist_orders.order_purchase_timestamp,
    olist_orders.order_id,
    SUM(olist_order_payments.payment_value) OVER (
        PARTITION BY olist_orders.customer_id
        ORDER BY olist_orders.order_purchase_timestamp
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS Running_Total_Sales
FROM [dbo].[olist_order_payments] olist_order_payments
INNER JOIN [dbo].[olist_orders] olist_orders
ON olist_order_payments.order_id = olist_orders.order_id;



