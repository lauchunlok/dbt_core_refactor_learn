SELECT
    id as customer_id,
    FIRST_NAME    as customer_first_name,
    LAST_NAME as customer_last_name
FROM  {{ source('jaffle_shop', 'customers') }}
