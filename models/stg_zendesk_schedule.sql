{{ config(enabled=var('using_schedules', True)) }}

with base as (

    select *
    from {{ var('schedule')}}

), fields as (
    
    select

      cast(id as {{ dbt_utils.type_string() }}) as schedule_id, --need to convert from numeric to string for downstream models to work properly
      end_time_utc,
      start_time_utc,
      name as schedule_name,
      created_at
      
    from base
    where not coalesce(_fivetran_deleted, false)

)

select *
from fields