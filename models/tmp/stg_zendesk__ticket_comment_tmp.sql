select {{ dbt_utils.star(source('zendesk', 'ticket_comment')) }}
from {{ var('ticket_comment') }}
