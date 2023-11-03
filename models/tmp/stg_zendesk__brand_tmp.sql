select {{ dbt_utils.star(from=source('zendesk', 'brand')) }}
from {{ var('brand') }}