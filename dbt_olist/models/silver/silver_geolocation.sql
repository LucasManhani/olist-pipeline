SELECT
    geolocation_zip_code_prefix AS location_zip_code,
    AVG(geolocation_lat) AS latencia,
    AVG(geolocation_lng) AS longitude,
    LOWER(unaccent(geolocation_city)) AS city,
    UPPER(geolocation_state) AS state
FROM {{ ref('bronze_geolocation') }}
GROUP BY
    geolocation_zip_code_prefix,
    geolocation_city,
    geolocation_state