{{ config(enabled=var('customer360__using_zendesk', true)) }}

select {{ dbt_utils.star(source('zendesk', 'ticket_tag')) }}
from {{ source('zendesk', 'ticket_tag') }} as ticket_tag_table
