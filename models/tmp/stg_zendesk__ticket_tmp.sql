{{ config(enabled=var('customer360__using_zendesk', true)) }}

select {{ dbt_utils.star(source('zendesk', 'ticket')) }}
from {{ source('zendesk', 'ticket') }} as ticket_table