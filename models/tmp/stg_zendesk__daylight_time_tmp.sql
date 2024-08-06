--To disable this model, set the using_schedules variable within your dbt_project.yml file to False.
{{ config(enabled=var('using_schedules', True) and var('customer360__using_zendesk', true)) }}

select {{ dbt_utils.star(source('zendesk', 'daylight_time')) }}
from {{ source('zendesk', 'daylight_time') }} as daylight_time_table