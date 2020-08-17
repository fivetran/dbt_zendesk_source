{{ config(enabled=var('using_schedules', True)) }}

with base as (

    select *
    from {{ var('ticket_schedule')}}

), fields as (
    
    select

      ticket_id,
      created_at,
      cast(schedule_id as string) as schedule_id,
      
    from base

)

select *
from fields