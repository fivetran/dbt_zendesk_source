--To disable this model, set the using_schedules or using_holidays variable within your dbt_project.yml file to False.
{{ config(enabled=var('using_schedules', True) and var('using_holidays', True)) }}

select {{ dbt_utils.star(source('zendesk', 'schedule_holiday')) }}
from {{ source('zendesk', 'schedule_holiday') }} as schedule_holiday_table