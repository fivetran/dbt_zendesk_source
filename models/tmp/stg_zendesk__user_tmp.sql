select {{ dbt_utils.star(source('zendesk','user')) }}   
from {{ source('zendesk','user') }} as user_table