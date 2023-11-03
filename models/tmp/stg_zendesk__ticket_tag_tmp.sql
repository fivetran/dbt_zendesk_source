select {{ dbt_utils.star(source('zendesk', 'ticket_tag')) }}
from {{ var('ticket_tag') }}
