select {{ dbt_utils.star(from=source('zendesk', 'group')) }}
from {{ var('group') }}
