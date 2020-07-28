{{ config(enabled=var('using_sla_policy', True)) }}

with base as (

    select *
    from {{ var('schedule')}}

), fields as (
    
    select

      id as schedule_id,
      end_time_utc,
      start_time_utc,
      name as schedule_name
      
    from base
    where not _fivetran_deleted

)

select *
from fields