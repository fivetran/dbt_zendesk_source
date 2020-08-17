{{ config(enabled=var('using_schedules', True)) }}

with base as (

    select *
    from {{ var('schedule')}}

), fields as (
    
    select

      cast(id as string) as schedule_id,
      end_time_utc,
      start_time_utc,
      name as schedule_name,
      created_at
      
    from base
    where not _fivetran_deleted

)

select *
from fields