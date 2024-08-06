{{ config(enabled=var('customer360__using_zendesk', true)) }}

select {{ dbt_utils.star(source('zendesk', 'ticket_comment')) }}
from {{ source('zendesk', 'ticket_comment') }} as ticket_comment_table