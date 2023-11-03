select {{ dbt_utils.star(source('zendesk', 'ticket')) }}
from {{ var('ticket') }}
