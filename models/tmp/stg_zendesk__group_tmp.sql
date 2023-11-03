select {{ dbt_utils.star(ref('group_data'))) }}
from {{ var('group') }}
