SELECT 
id as order_id,
user_id as customer_id,
ORDER_DATE AS order_placed_at,
STATUS AS order_status,

CASE
  WHEN order_status not in ('returned', 'return_pending') THEN order_date
END AS valid_order_date

FROM {{ source('jaffle_shop', 'orders') }}