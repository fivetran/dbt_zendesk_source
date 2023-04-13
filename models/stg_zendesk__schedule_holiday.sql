--To disable this model, set the using_schedules variable within your dbt_project.yml file to False.
{{ config(enabled=var('using_schedules', True)) }}

with base as (

    select * 
    from {{ ref('stg_zendesk__schedule_holiday_tmp') }}
),

fields as (

    select
        {{
            fivetran_utils.fill_staging_columns(
                source_columns=adapter.get_columns_in_relation(ref('stg_zendesk__schedule_holiday_tmp')),
                staging_columns=get_schedule_holiday_columns()
            )
        }}
    from base
),

final as (
    
    select
        _fivetran_deleted,
        _fivetran_synced,
        end_date as holiday_end_date_at,
        cast(id as {{ dbt.type_string() }}) as holiday_id,
        name as holiday_name,
        cast(schedule_id as {{ dbt.type_string() }}) as schedule_id,
        start_date as holiday_start_date_at
    from fields
)

select *
from final
