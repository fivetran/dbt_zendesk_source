{{ config(enabled=var('using_schedules', True) and var('using_schedule_histories', False)) }}

{{
    zendesk_source.union_zendesk_connections(
        connection_dictionary=var('zendesk_sources'), 
        single_source_name='zendesk', 
        single_table_name='audit_log'
    )
}}