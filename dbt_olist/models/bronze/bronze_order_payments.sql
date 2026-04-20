SELECT
    order_id,
    payment_sequential::integer AS payment_sequential,
    payment_type,
    payment_installments::integer AS payment_installments,
    payment_value::numeric AS payment_value
FROM {{ source('raw', 'olist_order_payments_dataset') }}