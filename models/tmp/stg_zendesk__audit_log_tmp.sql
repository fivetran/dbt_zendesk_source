{{ config(enabled=fivetran_utils.enabled_vars(['using_schedules','using_schedule_histories'])) }}

select {{ dbt_utils.star(source('zendesk','audit_log')) }}  
from {{ source('zendesk','audit_log') }} as audit_log_table