--4.5 SQL Server Validation and Reporting
--• Write a SQL query in SSMS to validate the data uploaded to SQL Server:
--o Query total sales per product category from the fact table.
--o Query the average delivery time per seller from the fact table.
--o Query the number of orders from each state from the customer dimension.
------------------------------------------------------------------------
-- Query total sales per product category from the fact table.
------------------------------------------------------------------------
select
dim_product.product_category_name_english
,SUM(payment_value) as total_sales
from
[fact].[order_items_payments] fact_order
inner join
[dim].[product] dim_product
on 
fact_order.product_id = dim_product.product_id
group by
dim_product.product_category_name_english;

-------------------------------------------------------------------------
-- Query the average delivery time per seller from the fact table.
-------------------------------------------------------------------------
SELECT
    fop.seller_id,
    AVG(DATEDIFF(day, d.order_purchase_timestamp, d.order_delivered_customer_date)) AS avg_delivery_day
FROM
    fact.order_items_payments fop
JOIN
    dim.date d ON fop.order_id = d.order_id
WHERE
    d.order_purchase_timestamp IS NOT NULL
    AND d.order_delivered_customer_date IS NOT NULL
    AND d.order_delivered_customer_date > d.order_purchase_timestamp
GROUP BY
    fop.seller_id;


--------------------------------------------------------------------------
-- Query the number of orders from each state from the customer dimension.
--------------------------------------------------------------------------
select
dim_customer.customer_state
,COUNT(*) as count_order
from
dim.date dim_date
INNER JOIN
dim.customer dim_customer
on
dim_date.customer_id = dim_customer.customer_id
group by dim_customer.customer_state