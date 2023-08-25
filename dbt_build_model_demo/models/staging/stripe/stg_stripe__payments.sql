with source as (
    
    select * from {{ source('stripe','raw_payments') }}

),

renamed as (

    select
        id as payment_id,
        order_id,
        payment_method,

        -- `amount` is currently stored in cents, so we convert it to dollars
        {{ cents_to_dollars('amount', 4) }}  as amount

    from source

)

select * from renamed
