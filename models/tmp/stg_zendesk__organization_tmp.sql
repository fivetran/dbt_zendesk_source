select {{ dbt_utils.star(source('zendesk', 'organization')) }}
from {{ var('organization') }}
