SELECT
    review_id,
    order_id,
    review_score,
    review_comment_title,
    review_comment_message,
    review_creation_date AS created_at,
    review_answer_timestamp AS answered_at
FROM {{ ref('bronze_order_reviews') }}