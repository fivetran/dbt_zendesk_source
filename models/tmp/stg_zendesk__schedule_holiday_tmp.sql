--To disable this model, set the using_schedules or using_holidays variable within your dbt_project.yml file to False.
{{ config(enabled=var('using_schedules', True) and var('using_holidays', True)) }}

{{
    fivetran_utils.union_data(
        table_identifier='schedule_holiday', 
        database_variable='zendesk_database', 
        schema_variable='zendesk_schema', 
        default_database=target.database,
        default_schema='zendesk',
        default_variable='schedule_holiday',
        union_schema_variable='zendesk_union_schemas',
        union_database_variable='zendesk_union_databases'
    )
}}