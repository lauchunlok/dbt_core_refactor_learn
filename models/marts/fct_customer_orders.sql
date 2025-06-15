
with

customers as (
  select * from {{ ref('stg_jaffle_shop__customers')}}
),

paid_orders as (
  select * from {{ ref('int_orders') }}
),

-- customer_orders as (
--   SELECT
--     customer.customer_id
--     , min(orders.order_date) as first_order_date
--     , max(orders.order_date) as last_order_date
--     , count(order.order_id) as number_of_orders
--   FROM customers
--   left join orders on orders.customer_id = customer.customer_id
--   group by 1
-- )


-- Final CTE
final AS (

  select
    paid_orders.order_id
    , paid_orders.customer_id
    , paid_orders.order_placed_at
    , paid_orders.order_status
    , paid_orders.total_amount_paid
    , paid_orders.payment_finalized_date

    , customers.customer_first_name
    , customers.customer_last_name

    -- sales transaction sequence
    , ROW_NUMBER() over (order by paid_orders.order_id) as transaction_seq

    -- customer sales sequence
    , ROW_NUMBER() over (PARTITION by paid_orders.customer_id order by paid_orders.order_id) as transaction_seq


    -- new vs. returning customer
    , case
        when (
          rank() over (
            PARTITION by paid_orders.customer_id 
            order by paid_orders.order_placed_at, paid_orders.order_id) = 1
        ) 
        then "new"
        else 'return'
      end as nvsr
    
    -- customer lifetime value
    , sum(paid_orders.total_amount_paid) over (
      PARTITION by paid_orders.customer_id order by paid_orders.order_placed_at) as customer_lifetime_value

    -- first day of sales
    , first_value(paid_orders.order_placed_at) over (
      PARTITION by paid_orders.customer_id order by paid_orders.order_placed_at) as fdos

  from paid_orders
  left join customers on paid_orders.customer_id = customers.customer_id

)

SELECT * FROM final