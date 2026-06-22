WITH normalized AS (
    SELECT
        LPAD(geolocation_zip_code_prefix, 5, '0') AS location_zip_code,
        geolocation_lat,
        geolocation_lng,
        LOWER(TRIM(geolocation_city)) AS city,
        UPPER(TRIM(geolocation_state)) AS state
    FROM {{ ref('bronze_geolocation') }}
),

coordinates AS (
    SELECT
        location_zip_code,
        AVG(geolocation_lat) AS latitude,
        AVG(geolocation_lng) AS longitude
    FROM normalized
    GROUP BY location_zip_code
),

label_counts AS (
    SELECT
        location_zip_code,
        city,
        state,
        COUNT(*) AS occurrences
    FROM normalized
    GROUP BY location_zip_code, city, state
),

ranked_labels AS (
    SELECT
        location_zip_code,
        city,
        state,
        ROW_NUMBER() OVER (
            PARTITION BY location_zip_code
            ORDER BY (city IS NULL), occurrences DESC, city, state
        ) AS label_rank
    FROM label_counts
)

SELECT
    coordinates.location_zip_code,
    coordinates.latitude,
    coordinates.longitude,
    ranked_labels.city,
    ranked_labels.state
FROM coordinates
LEFT JOIN ranked_labels
    ON coordinates.location_zip_code = ranked_labels.location_zip_code
    AND ranked_labels.label_rank = 1
