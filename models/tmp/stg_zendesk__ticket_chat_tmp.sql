{{ config(enabled=var('using_ticket_chat', False)) }}

{{
    zendesk_source.union_zendesk_connections(
        connection_dictionary=var('zendesk_sources'), 
        single_source_name='zendesk', 
        single_table_name='ticket_chat'
    )
}}