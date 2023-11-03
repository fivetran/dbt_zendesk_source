select {{ dbt_utils.star(fivetran_utils.snowflake_seed_data('user_data')) }}   
from {{ var('user') }}