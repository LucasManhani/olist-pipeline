SELECT
    product_category_name,
    product_category_name_english
FROM {{ ref('bronze_product_category_name_translation') }}