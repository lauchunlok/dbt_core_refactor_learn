SELECT 
  order_id,
  max(created_at) as payment_finalized_date, 
  sum(amount_dollar) as total_amount_paid
FROM {{ ref('stg_stripe__payments') }}
where STATUS <> 'fail'
group by 1

