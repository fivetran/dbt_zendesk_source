select {{ dbt_utils.star(from=source('zendesk', 'ticket')) }}
from {{ var('ticket') }}
