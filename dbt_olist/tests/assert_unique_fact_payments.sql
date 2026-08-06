SELECT
    order_id,
    payment_sequential,
    COUNT(*) AS duplicate_count
FROM {{ ref('fact_payments') }}
GROUP BY order_id, payment_sequential
HAVING COUNT(*) > 1
