select {{ dbt_utils.star(from=source('zendesk', 'ticket_tag')) }}
from {{ var('ticket_tag') }}
