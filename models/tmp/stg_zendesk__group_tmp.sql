{{ config(enabled=var('customer360__using_zendesk', true)) }}

select {{ dbt_utils.star(source('zendesk','group')) }}  
from {{ source('zendesk','group') }} as group_table