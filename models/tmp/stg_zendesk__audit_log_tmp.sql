{{ config(enabled=var('using_schedules', True) and var('using_schedule_histories', False)) }}

select {{ dbt_utils.star(source('zendesk','audit_log')) }}  
from {{ source('zendesk','audit_log') }} as audit_log_table