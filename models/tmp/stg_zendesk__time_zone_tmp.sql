--To disable this model, set the using_schedules variable within your dbt_project.yml file to False.
{{ config(enabled=var('using_schedules', True) and var('customer360__using_zendesk', true)) }}

select {{ dbt_utils.star(source('zendesk', 'time_zone')) }} 
from {{ source('zendesk', 'time_zone') }} as time_zone_table
