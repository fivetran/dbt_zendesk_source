select {{ dbt_utils.star(source('zendesk', 'brand')) }}
from {{ var('brand') }}