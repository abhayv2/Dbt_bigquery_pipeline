with payments as (
    select orderid as order_id,
           paymentmethod,
           status as payment_status,
           amount
    from `dbt-tutorial.data_prep.stripe_payments`
),

orders as (
    select id as order_id,
           user_id as customer_id
    from `dbt-tutorial.data_prep.jaffle_shop_orders`
),

customer_payments as (
    select
        o.customer_id,
        sum(case when p.payment_status = 'success' then p.amount else 0 end) as total_amount,
        count(case when p.payment_status = 'success' then 1 else null end) as successful_payments,
        count(case when p.payment_status = 'fail' then 1 else null end) as failed_payments
    from orders o
    left join payments p on o.order_id = p.order_id
    group by o.customer_id
)

select * from customer_payments