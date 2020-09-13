with base as (

    select *
    from {{ var('ticket_tag')}}

), fields as (
    
    select

      ticket_id,
      'tag' as tags
      
    from base

)

select *
from fields