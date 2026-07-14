WITH dates AS (

    SELECT purchased_at::date AS full_date
    FROM {{ ref('silver_orders') }}

    UNION

    SELECT approved_at::date AS full_date
    FROM {{ ref('silver_orders') }}

    UNION

    SELECT shipped_at::date AS full_date
    FROM {{ ref('silver_orders') }}

    UNION

    SELECT delivered_at::date AS full_date
    FROM {{ ref('silver_orders') }}

    UNION

    SELECT estimated_delivery_at::date AS full_date
    FROM {{ ref('silver_orders') }}

)

SELECT
    TO_CHAR(full_date, 'YYYYMMDD')::int AS date_id,
    full_date,
    EXTRACT(YEAR FROM full_date)::int AS year,
    EXTRACT(MONTH FROM full_date)::int AS month,
    EXTRACT(QUARTER FROM full_date)::int AS quarter,
    TO_CHAR(full_date, 'YYYY-MM') AS year_month
FROM dates
WHERE full_date IS NOT NULL