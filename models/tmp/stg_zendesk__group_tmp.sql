select {{ dbt_utils.star(source('zendesk', 'group')) }}
from {{ var('group') }}
