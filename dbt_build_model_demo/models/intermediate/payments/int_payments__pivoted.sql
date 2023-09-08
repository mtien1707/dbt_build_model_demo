{% set payment_methods = ['credit_card', 'coupon', 'bank_transfer', 'gift_card'] %}

with 
    payments as (
        select * 
        from {{ ref('stg_stripe__payments') }}
    )

    , orders as(
        select * 
        from {{ ref('stg_jaffle_shop__orders') }}
    )
    
    , pivoted as (
        select
            order_id,
            {% for payment_method in payment_methods -%}
            sum(case when payment_method = '{{ payment_method }}' then amount else 0 end)  as {{ payment_method }}_amount

            {%- if not loop.last -%}
            ,
            {%- endif %}
            {% endfor -%}
        from payments 
        left join orders using (order_id) 
        where orders.status IN ('completed')
        group by 1
    )

select * 
from pivoted 