select {{ dbt_utils.star(source('zendesk', 'ticket_field_history')) }}
from {{ source('zendesk', 'ticket_field_history') }}