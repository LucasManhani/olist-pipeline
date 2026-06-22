SELECT
    order_id,
    order_item_id,
    COUNT(*) AS duplicate_count
FROM {{ ref('silver_order_items') }}
GROUP BY order_id, order_item_id
HAVING COUNT(*) > 1
