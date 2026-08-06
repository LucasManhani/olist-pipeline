SELECT
    payments.order_id,
    payments.payment_sequential,
    payments.payment_type,
    payments.payment_installments,
    payments.payment_value,
    orders.customer_id,

    TO_CHAR(orders.purchased_at, 'YYYYMMDD')::int AS purchase_date_id,

    orders.purchased_at
FROM {{ ref('silver_order_payments') }} AS payments
LEFT JOIN {{ ref('silver_orders') }} AS orders
    ON payments.order_id = orders.order_id
