select {{ dbt_utils.star(from=source('zendesk', 'ticket_comment')) }}
from {{ var('ticket_comment') }}
