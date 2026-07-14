SELECT 
    date_trunc('month', o.purchased_at) AS month,
    COUNT(DISTINCT o.order_id) AS total_orders,
    SUM(op.payment_value) AS total_revenue
FROM {{ ref('silver_orders') }} o
LEFT JOIN {{ ref('silver_order_payments') }} op 
    ON o.order_id = op.order_id
GROUP BY 1
ORDER BY 1