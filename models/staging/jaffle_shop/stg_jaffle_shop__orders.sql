SELECT 
id as order_id,
user_id as customer_id,
ORDER_DATE AS order_placed_at,
STATUS AS order_status

FROM {{ source('jaffle_shop', 'orders') }}