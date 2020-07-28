{{ config(enabled=var('using_sla_policy', True)) }}

with base as (

    select *
    from {{ var('ticket_schedule')}}

), fields as (
    
    select

      ticket_id,
      created_at,
      schedule_id,
      
    from base

)

select *
from fields