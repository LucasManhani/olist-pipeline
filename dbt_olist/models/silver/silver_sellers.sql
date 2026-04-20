SELECT
    seller_id,
    seller_zip_code_prefix AS zip_code,
    LOWER(unaccent(seller_city)) AS city,
    UPPER(seller_state) AS state
FROM {{ ref('bronze_sellers') }}