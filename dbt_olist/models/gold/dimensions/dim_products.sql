SELECT 
    products.product_id,
    COALESCE(products.product_category_name, 'sem_categoria') AS product_category_name,
    products.photos_qty,
    products.weight_g,
    products.length_cm,
    products.height_cm,
    products.width_cm
FROM {{ ref('silver_products') }} AS products
