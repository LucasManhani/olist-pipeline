SELECT
    DATE_TRUNC('month', o.purchased_at) AS month,
    t.product_category_name_english AS category,
    ROUND(SUM(oi.price + oi.freight_value)::numeric, 2) AS total_revenue
FROM {{ ref('silver_orders') }} o
INNER JOIN {{ ref('silver_order_items') }} oi 
    ON o.order_id = oi.order_id
INNER JOIN {{ ref('silver_products') }} p 
    ON oi.product_id = p.product_id
LEFT JOIN {{ ref('silver_product_category_name_translation') }} t
    ON p.product_category_name = t.product_category_name
GROUP BY 1, 2
ORDER BY 1, 3 DESC