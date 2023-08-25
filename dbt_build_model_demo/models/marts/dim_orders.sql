with
    orders as  (
        select *
        from {{ ref('stg_jaffle_shop__orders' )}}
    )
    
    , payments as (
        select *
        from {{ ref('stg_stripe__payments') }}
    )
    
    , order_payments as (
        select
            order_id
            , sum(case when status = 'success' then amount end) as amount
        from payments
        left join orders using (order_id)
        group by 1
    )

    , final AS (
        select
            orders.order_id
            , orders.customer_id
            , orders.order_date
            , orders.status
            , coalesce(order_payments.amount, 0) as amount
        from orders left join order_payments using (order_id)
    )

select *
from final