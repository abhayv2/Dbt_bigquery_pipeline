with orders as (
    select id as order_id,
           user_id as customer_id,
           order_date,
           status
    from `dbt-tutorial.data_prep.jaffle_shop_orders`
),

payments as (
    select orderid as order_id,
           paymentmethod,
           status as payment_status,
           amount
    from `dbt-tutorial.data_prep.stripe_payments`
),

order_payments as (
    select
        o.order_id,
        o.customer_id,
        o.order_date,
        o.status as order_status,
        sum(case when p.payment_status = 'success' then p.amount else 0 end) as total_successful_payments,
        count(case when p.payment_status = 'fail' then 1 else null end) as failed_payments
    from orders o
    left join payments p on o.order_id = p.order_id
    group by o.order_id, o.customer_id, o.order_date, o.status
)

select * from order_payments
