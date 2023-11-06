select {{ dbt_utils.star(source('zendesk', 'organization')) }}
from {{  source('zendesk','organization') }}