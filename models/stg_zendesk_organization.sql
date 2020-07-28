with base as (

    select *
    from {{ var('organization')}}

), fields as (

    select

      id as organization_id,
      details,
      name

    from base

)

select *
from fields