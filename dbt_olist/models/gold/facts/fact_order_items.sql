SELECT
    oitems.order_id,
    oitems.order_item_id,
    oitems.product_id,
    oitems.seller_id,

    TO_CHAR(oitems.shipping_limit_at, 'YYYYMMDD')::int AS shipping_limit_date_id,

    oitems.shipping_limit_at,
    oitems.price,
    oitems.freight_value,

    oitems.price + oitems.freight_value AS item_total_value

FROM {{ ref('silver_order_items') }} AS oitems
