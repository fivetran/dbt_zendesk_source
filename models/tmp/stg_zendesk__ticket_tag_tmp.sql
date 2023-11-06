select {{ dbt_utils.star(source('zendesk', 'ticket_tag')) }}
from {{ source('zendesk', 'ticket_tag') }}
