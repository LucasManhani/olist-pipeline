SELECT
    customers.customer_id,
    customers.customer_unique_id,
    customers.zip_code,
    customers.city,
    customers.state,
    geolocation.latitude,
    geolocation.longitude
FROM {{ ref('silver_customers') }} AS customers
LEFT JOIN {{ ref('silver_geolocation') }} AS geolocation
    ON customers.zip_code = geolocation.location_zip_code