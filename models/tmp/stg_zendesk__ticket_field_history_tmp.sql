select {{ dbt_utils.star(from=source('zendesk', 'ticket_field_history')) }}
from {{ var('ticket_field_history') }}
