SELECT
    DATE_TRUNC('month', o.purchased_at) AS month,
    op.payment_type,
    COUNT(DISTINCT o.order_id) AS total_orders,
    ROUND(SUM(op.payment_value)::numeric, 2) AS total_revenue
FROM {{ ref('silver_orders') }} o
LEFT JOIN {{ ref('silver_order_payments') }} op 
    ON o.order_id = op.order_id
GROUP BY 1, 2
ORDER BY 1, 4 DESC