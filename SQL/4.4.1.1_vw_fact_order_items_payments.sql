--4.4 Saving Processed Data to SQL Server (Fact & Dimension Tables)
--• After cleaning and transforming the data, split it into a fact table and 3-4 dimension tables:
--o Fact Table: Order Items with calculated columns (Total Price, Delivery Time, etc.).

CREATE VIEW vw_fact_order_items_payments AS
SELECT 
    olist_order_items.[order_id],
    olist_order_items.[order_item_id],
    olist_order_items.[product_id],
    olist_order_items.[seller_id],
    olist_order_items.[shipping_limit_date],
    olist_order_items.[price],
    olist_order_items.[freight_value],
    olist_order_items.[total_price],
    olist_order_items.[profit_margin],

    olist_order_payments.[payment_sequential],
    olist_order_payments.[payment_type],
    olist_order_payments.[payment_installments],
    olist_order_payments.[payment_value],

    -- Use existing delivery_time directly from the orders table
    olist_orders.delivery_time

FROM [dbo].[olist_order_items] olist_order_items
INNER JOIN [dbo].[olist_order_payments] olist_order_payments
    ON olist_order_items.order_id = olist_order_payments.order_id
INNER JOIN [dbo].[olist_orders] olist_orders
    ON olist_order_items.order_id = olist_orders.order_id
WHERE olist_orders.order_status = 'delivered';
