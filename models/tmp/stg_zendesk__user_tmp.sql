select {{ dbt_utils.star(source('zendesk', 'user')) }}   
from {{ var('user') }}
