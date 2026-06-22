SELECT
    seller_id,
    LPAD(seller_zip_code_prefix, 5, '0') AS zip_code,
    LOWER(TRIM(seller_city)) AS city,
    UPPER(seller_state) AS state
FROM {{ ref('bronze_sellers') }}
