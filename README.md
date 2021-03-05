# Zendesk Support (Source)

This package models Zendesk Support data from [Fivetran's connector](https://fivetran.com/docs/applications/zendesk). It uses data in the format described by [this ERD](https://fivetran.com/docs/applications/zendesk#schemainformation).

This package enriches your Fivetran data by doing the following:

* Adds descriptions to tables and columns that are synced using Fivetran
* Adds column-level testing where applicable. For example, all primary keys are tested for uniqueness and non-null values.
* Models staging tables, which will be used in our transform package

## Models

This package contains staging models, designed to work simultaneously with our [Zendesk Support transformation package](https://github.com/fivetran/dbt_zendesk). The staging models name columns consistently across all packages:
* Boolean fields are prefixed with `is_` or `has_`
* Timestamps are appended with `_at`
* ID primary keys are prefixed with the name of the table. For example, the ticket table's ID column is renamed `ticket_id`.

## Installation Instructions
Check [dbt Hub](https://hub.getdbt.com/) for the latest installation instructions, or [read the dbt docs](https://docs.getdbt.com/docs/package-management) for more information on installing packages.

## Configuration
By default, this package looks for your Zendesk data in the `zendesk` schema of your [target database](https://docs.getdbt.com/docs/running-a-dbt-project/using-the-command-line-interface/configure-your-profile). If this is not where your Zendesk Support data is, add the following configuration to your `dbt_project.yml` file:

```yml
# dbt_project.yml

...
config-version: 2

vars:
    zendesk_schema: your_schema_name
    zendesk_database: your_database_name
```

Additionally, by default this package will write to a schema titled (target.schema + `_zendesk_staging` within your target database. If this is not where you would like you Zendesk Support staging data to be written to, add the following configuration to your `dbt_project.yml` file:

```yml
# dbt_project.yml

...
config-version: 2

models:
    zendesk_source:
        +schema: my_new_schema_name
```

### Disabling Models
This package takes into consideration that not every Zendesk account utilizes the `schedule`, `domain_name`, `user_tag`, `organization_tag`, or `ticket_form_history` features, and allows you to disable the corresponding functionality. By default, all variables' values are assumed to be `true`. Add variables for only the tables you want to disable:
```yml
# dbt_project.yml

...
vars:
    using_schedules:            False         #Disable if you are not using schedules
    using_domain_names:         False         #Disable if you are not using domain names
    using_user_tags:            False         #Disable if you are not using user tags
    using_ticket_form_history:  False         #Disable if you are not using ticket form history
    using_organization_tags:    False         #Disable if you are not using organization tags
```

## Contributions

Additional contributions to this package are very welcome! Please create issues
or open PRs against `master`. Check out 
[this post](https://discourse.getdbt.com/t/contributing-to-a-dbt-package/657) 
on the best workflow for contributing to a package.

## Resources:
- Find all of Fivetran's pre-built dbt packages in our [dbt hub](https://hub.getdbt.com/fivetran/)
- Provide [feedback](https://www.surveymonkey.com/r/DQ7K7WW) on our existing dbt packages or what you'd like to see next
- Learn more about Fivetran [here](https://fivetran.com/docs)
- Check out [Fivetran's blog](https://fivetran.com/blog)
- Learn more about dbt [in the docs](https://docs.getdbt.com/docs/introduction)
- Check out [Discourse](https://discourse.getdbt.com/) for commonly asked questions and answers
- Join the [chat](http://slack.getdbt.com/) on Slack for live discussions and support
- Find [dbt events](https://events.getdbt.com) near you
- Check out [the blog](https://blog.getdbt.com/) for the latest news on dbt's development and best practices
