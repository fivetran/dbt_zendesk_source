select {{ dbt_utils.star(source('zendesk','brand')) }}  
from {{ source('zendesk','brand') }} as brand_table