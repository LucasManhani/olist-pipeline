SELECT
    DATE_TRUNC('month', o.purchased_at) AS month,
    ROUND(SUM(op.payment_value) / COUNT(DISTINCT o.order_id), 2) AS medium_ticket
FROM {{ ref('silver_orders') }} o
LEFT JOIN {{ ref('silver_order_payments') }} op 
    ON o.order_id = op.order_id
GROUP BY 1
ORDER BY 1