SELECT
    sellers.seller_id,
    sellers.zip_code,
    sellers.city,
    sellers.state,
    geolocation.latitude,
    geolocation.longitude
FROM {{ ref('silver_sellers') }} AS sellers
LEFT JOIN {{ ref('silver_geolocation') }} AS geolocation
    ON sellers.zip_code = geolocation.location_zip_code
