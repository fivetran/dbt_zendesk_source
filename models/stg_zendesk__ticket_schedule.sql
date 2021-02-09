{{ config(enabled=var('using_schedules', True)) }}

with base as (

    select * 
    from {{ ref('stg_zendesk__ticket_schedule_tmp') }}

),

fields as (

    select
        {{
            fivetran_utils.fill_staging_columns(
                source_columns=adapter.get_columns_in_relation(ref('stg_zendesk__ticket_schedule_tmp')),
                staging_columns=get_ticket_schedule_columns()
            )
        }}
        
    from base
),

final as (
    
    select 
        ticket_id,
        created_at,
        cast(schedule_id as {{ dbt_utils.type_string() }}) as schedule_id --need to convert from numeric to string for downstream models to work properly
    from fields
)

select * 
from final
