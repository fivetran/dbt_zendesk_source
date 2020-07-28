{{ config(enabled=var('using_sla_policy', True)) }}

with base as (

    select *
    from {{ var('sla_policy_history')}}

), fields as (
    
    select

      id as sla_policy_id,
      _fivetran_deleted,
      created_at,
      updated_at,
      description,
      title
      
      
    from base

)

select *
from fields