select {{ dbt_utils.star(fivetran_utils.seed_data_helper('brand_data',['postgres'])) }}
from {{ var('brand') }}