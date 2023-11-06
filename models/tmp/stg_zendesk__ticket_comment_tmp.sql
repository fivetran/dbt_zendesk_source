select {{ dbt_utils.star(source('zendesk', 'ticket_comment')) }}
from {{ source('zendesk', 'ticket_comment') }}