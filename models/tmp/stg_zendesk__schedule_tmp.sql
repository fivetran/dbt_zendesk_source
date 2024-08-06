--To disable this model, set the using_schedules variable within your dbt_project.yml file to False.
{{ config(enabled=var('using_schedules', True) and var('customer360__using_zendesk', true)) }}

select {{ dbt_utils.star(source('zendesk', 'schedule')) }}
from {{ source('zendesk', 'schedule') }} as schedule_table