SELECT
    DATE_TRUNC('month', purchased_at) AS month,
    ROUND(
        COUNT(CASE WHEN order_status = 'canceled' THEN 1 END) * 100.0 / COUNT(order_id),
        2
    ) AS cancellation_rate
FROM {{ ref('silver_orders') }}
GROUP BY 1
ORDER BY 1