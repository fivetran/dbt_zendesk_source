{{ config(enabled=var('using_sla_policy', True)) }}

with base as (

    select *
    from {{ var('ticket_sla_policy')}}

), fields as (
    
    select
      
      sla_policy_id,
      ticket_id,
      policy_applied_at

    from base
)

select *
from fields