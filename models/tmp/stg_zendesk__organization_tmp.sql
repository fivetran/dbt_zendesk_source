select {{ dbt_utils.star(from=source('zendesk', 'organization')) }}
from {{ var('organization') }}
