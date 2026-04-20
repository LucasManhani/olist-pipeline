SELECT
    order_id,
    order_item_id::integer AS order_item_id,
    product_id,
    seller_id,
    shipping_limit_date::timestamp AS shipping_limit_date,
    price::numeric AS price,
    freight_value::numeric AS freight_value
FROM {{ source('raw', 'olist_order_items_dataset') }}