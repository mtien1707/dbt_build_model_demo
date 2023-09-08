{{ config(materialized='view', bind=False) }}
with source as (

    select * from {{ source('myspectrum_schema', 'involved_party') }} 

),

renamed as (

    select
        *

    from source

)

select * from renamed 