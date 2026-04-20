SELECT
    product_id,
    product_category_name,
    product_name_lenght::integer AS product_name_lenght,
    product_description_lenght::integer AS product_description_lenght,
    product_photos_qty::integer AS product_photos_qty,
    product_weight_g::numeric AS product_weight_g,
    product_length_cm::numeric AS product_length_cm,
    product_height_cm::numeric AS product_height_cm,
    product_width_cm::numeric AS product_width_cm
FROM {{ source('raw', 'olist_products_dataset') }}