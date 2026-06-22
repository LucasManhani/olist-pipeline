SELECT
    customer_id,
    customer_unique_id,
    LPAD(customer_zip_code_prefix, 5, '0') AS zip_code,
    LOWER(TRIM(customer_city)) AS city,
    UPPER(customer_state) AS state
FROM {{ ref('bronze_customers') }}
