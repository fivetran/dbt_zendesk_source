{% macro zendesk_fill_pass_through_columns(pass_through_variable, except=[]) %}

{% if pass_through_variable %}
    {% for field in pass_through_variable %}
        {% if field is mapping %}
            {% set field_name = field.alias if field.alias else field.name %}
            {% if field_name not in except %}
                {% if field.transform_sql %}
                    , {{ field.transform_sql }} as {{ field.alias if field.alias else field.name }}
                {% else %}
                    , {{ field.alias if field.alias else field.name }}
                {% endif %}
            {% endif %}
        {% else %}
            {% if field not in except %}
                , {{ field }}
            {% endif %}
        {% endif %}
    {% endfor %}
{% endif %}

{% endmacro %}