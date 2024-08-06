{{ config(enabled=var('customer360__using_zendesk', true)) }}

select {{ dbt_utils.star(source('zendesk', 'ticket_field_history')) }}
from {{ source('zendesk', 'ticket_field_history') }} as ticket_field_history_table