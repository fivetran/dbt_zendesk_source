select {{ dbt_utils.star(from=source('zendesk', 'user')) }}   
from {{ var('user') }}
