
{{ config(enabled=var('using_schedules', True)) }}

with base as (

    select * 
    from {{ ref('stg_zendesk__schedule_tmp') }}

),

fields as (

    select
        {{
            fivetran_utils.fill_staging_columns(
                source_columns=adapter.get_columns_in_relation(ref('stg_zendesk__schedule_tmp')),
                staging_columns=get_schedule_columns()
            )
        }}
        
    from base
),

final as (
    
    select 
        cast(id as {{ dbt_utils.type_string() }}) as schedule_id, --need to convert from numeric to string for downstream models to work properly
        end_time_utc,
        start_time_utc,
        name as schedule_name,
        created_at
    from fields
    where not coalesce(_fivetran_deleted, false)
)

select * 
from final
