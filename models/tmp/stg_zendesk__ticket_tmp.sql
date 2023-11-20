select {{ dbt_utils.star(source('zendesk', 'ticket')) }}
from {{ source('zendesk', 'ticket') }} as ticket_table