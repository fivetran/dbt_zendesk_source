with base as (

    select *
    from {{ var('ticket_tag')}}

), fields as (
    
    select

      ticket_id,
      {% if target.type == 'redshift' %}
      "tag" as tags
      {% else %}
      tag as tags
      {% endif %}
      
    from base

)

select *
from fields