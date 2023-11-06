select {{ dbt_utils.star(source('zendesk','group')) }}  
from {{ source('zendesk','group') }}