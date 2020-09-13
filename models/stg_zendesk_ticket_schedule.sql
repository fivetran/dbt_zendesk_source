{{ config(enabled=var('using_schedules', True)) }}

with base as (

    select *
    from {{ var('ticket_schedule')}}

), fields as (
    
    select

      ticket_id,
      created_at,
      cast(schedule_id as {{ dbt_utils.type_string() }}) as schedule_id --need to convert from numeric to string for downstream models to work properly

    from base

)

select *
from fields