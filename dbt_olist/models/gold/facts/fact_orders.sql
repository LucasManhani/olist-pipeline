SELECT
    orders.order_id,
    orders.customer_id,
    orders.order_status,

    TO_CHAR(orders.purchased_at, 'YYYYMMDD')::int AS purchase_date_id,
    TO_CHAR(orders.approved_at, 'YYYYMMDD')::int AS approved_date_id,
    TO_CHAR(orders.shipped_at, 'YYYYMMDD')::int AS shipped_date_id,
    TO_CHAR(orders.delivered_at, 'YYYYMMDD')::int AS delivered_date_id,
    TO_CHAR(orders.estimated_delivery_at, 'YYYYMMDD')::int AS estimated_delivery_date_id,

    orders.purchased_at,
    orders.approved_at,
    orders.shipped_at,
    orders.delivered_at,
    orders.estimated_delivery_at

FROM {{ ref('silver_orders') }} AS orders