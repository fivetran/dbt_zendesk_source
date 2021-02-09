{{ config(enabled=var('using_schedules', True)) }}

select * 
from {{ var('ticket_schedule') }}
