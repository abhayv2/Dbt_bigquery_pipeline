with cleaned_customers as (
    select
        id,
        trim(lower(first_name)) as first_name,
        trim(lower(last_name)) as last_name
    from `dbt-tutorial.data_prep.jaffle_shop_customers`
)
select * from cleaned_customers
