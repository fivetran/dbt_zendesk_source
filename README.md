# Zendesk Support Source dbt Package ([Docs](https://fivetran.github.io/dbt_zendesk_source/))

<p align="left">
    <a alt="License"
        href="https://github.com/fivetran/dbt_zendesk_source/blob/main/LICENSE">
        <img src="https://img.shields.io/badge/License-Apache%202.0-blue.svg" /></a>
    <a alt="dbt-core">
        <img src="https://img.shields.io/badge/dbt_Core™_version->=1.3.0_<2.0.0-orange.svg" /></a>
    <a alt="Maintained?">
        <img src="https://img.shields.io/badge/Maintained%3F-yes-green.svg" /></a>
    <a alt="PRs">
        <img src="https://img.shields.io/badge/Contributions-welcome-blueviolet" /></a>
    <a alt="Fivetran Quickstart Compatible"
        href="https://fivetran.com/docs/transformations/dbt/quickstart">
        <img src="https://img.shields.io/badge/Fivetran_Quickstart_Compatible%3F-yes-green.svg" /></a>
</p>

## What does this dbt package do?
<!--section="zendesk_source_model"-->
- Materializes [Zendesk Support staging tables](https://fivetran.github.io/dbt_zendesk_source/#!/overview/zendesk_source/models/?g_v=1) which leverage data in the format described by [this ERD](https://fivetran.com/docs/applications/zendesk#schemainformation). These staging tables clean, test, and prepare your Zendesk Support data from [Fivetran's connector](https://fivetran.com/docs/applications/zendesk) for analysis by doing the following:
  - Name columns for consistency across all packages and for easier analysis
  - Adds freshness tests to source data
    - dbt Core >= 1.9.6 is required to run freshness tests out of the box.
  - Adds column-level testing where applicable. For example, all primary keys are tested for uniqueness and non-null values.
- Generates a comprehensive data dictionary of your Zendesk Support data through the [dbt docs site](https://fivetran.github.io/dbt_zendesk_source/).
- These tables are designed to work simultaneously with our [Zendesk Support transformation package](https://github.com/fivetran/dbt_zendesk).
<!--section-end-->

## How do I use the dbt package?
### Step 1: Prerequisites
To use this dbt package, you must have the following:
- A Fivetran Zendesk Support connection syncing data into your destination.
- A **BigQuery**, **Snowflake**, **Redshift**, **PostgreSQL**, or **Databricks** destination.

#### Databricks Dispatch Configuration
If you are using a Databricks destination with this package you will need to add the below (or a variation of the below) dispatch configuration within your `dbt_project.yml`. This is required in order for the package to accurately search for macros within the `dbt-labs/spark_utils` then the `dbt-labs/dbt_utils` packages respectively.
```yml
dispatch:
  - macro_namespace: dbt_utils
    search_order: ['spark_utils', 'dbt_utils']
```

### Step 2: Install the package (skip if using `zendesk` transformation package)
Include the following zendesk_source package version in your `packages.yml` file **only if you are NOT also installing the [Zendesk Support transformation package](https://github.com/fivetran/dbt_zendesk)**. The transform package has a dependency on this source package.
> TIP: Check [dbt Hub](https://hub.getdbt.com/) for the latest installation instructions or [read the dbt docs](https://docs.getdbt.com/docs/package-management) for more information on installing packages.
```yaml
packages:
  - package: fivetran/zendesk_source
    version: [">=0.18.0", "<0.19.0"]
```
### Step 3: Define database and schema variables
#### Option A: Single connection
By default, this package runs using your target database and the `zendesk` schema. If this is not where your Zendesk Support data is (for example, if your zendesk schema is named `zendesk_fivetran`), add the following configuration to your root `dbt_project.yml` file:

```yml
vars:
    zendesk_database: your_destination_name
    zendesk_schema: your_schema_name 
```
> **Note**: When running the package with a single source connection, the `source_relation` column in each model will be populated with an empty string.

#### Option B: Union multiple connections
If you have multiple Zendesk connections in Fivetran and would like to use this package on all of them simultaneously, we have provided functionality to do so. For each source table, the package will union all of the data together and pass the unioned table into the transformations. The `source_relation` column in each model indicates the origin of each record. 

To use this functionality, you will need to set the `zendesk_sources` variable in your root `dbt_project.yml` file:

```yml
# dbt_project.yml

vars:
  zendesk_sources:
    - database: connection_1_destination_name # Required
      schema: connection_1_schema_name # Rquired
      name: connection_1_source_name # Required only if following the step in the following subsection

    - database: connection_2_destination_name
      schema: connection_2_schema_name
      name: connection_2_source_name
```

##### Recommended: Incorporate unioned sources into DAG
> *If you are running the package through [Fivetran Transformations for dbt Core™](https://fivetran.com/docs/transformations/dbt#transformationsfordbtcore), the below step is necessary in order to synchronize model runs with your Zendesk connections.*

By default, this package defines one single-connection source, called `zendesk`, which will be disabled if you are unioning multiple connections. This means that your DAG will not include your Zendesk sources, though the package will run successfully.

To properly incorporate all of your Zendesk connections into your project's DAG:
1. Define each of your sources in a `.yml` file in your project. Utilize the following template for the `source`-level configurations, and, **most importantly**, copy and paste the table and column-level definitions from the package's `src_zendesk.yml` [file](https://github.com/fivetran/dbt_zendesk_source/blob/main/models/src_zendesk.yml#L15-L351).

```yml
# a .yml file in your root project
sources:
  - name: <name> # ex: Should match name in zendesk_sources
    schema: <schema_name>
    database: <database_name>
    loader: fivetran
    loaded_at_field: _fivetran_synced
      
    freshness: # feel free to adjust to your liking
      warn_after: {count: 72, period: hour}
      error_after: {count: 168, period: hour}

    tables: # copy and paste from models/src_zendesk.yml - see https://support.atlassian.com/bitbucket-cloud/docs/yaml-anchors/ for how to use anchors to only do so once
```

> **Note**: If there are source tables you do not have (see [Step 4](https://github.com/fivetran/dbt_zendesk_source?tab=readme-ov-file#step-4-disable-models-for-non-existent-sources)), still include them in this source definition.

2. Set the `has_defined_sources` variable (scoped to the `zendesk_source` package) to `True`, like such:
```yml
# dbt_project.yml
vars:
  zendesk_source:
    has_defined_sources: true
```

### Step 4: Enable/Disable models for non-existent sources
> _This step is optional if you are unioning multiple connections together in the previous step. The `union_data` macro will create empty staging models for sources that are not found in any of your Zendesk schemas/databases. However, you can still leverage the below variables if you would like to avoid this behavior._

This package takes into consideration that not every Zendesk Support account utilizes the `schedule`, `schedule_holiday`, `ticket_schedule`, `daylight_time`, `time_zone`, `audit_log`, `domain_name`, `user_tag`,  `brand`, `organization`, `organization_tag`, `ticket_form_history`, `ticket_chat`, or `ticket_chat_event` features, and allows you to disable the corresponding functionality.

By default, all variables' values are assumed to be `true`, except for `using_audit_log` and `using_ticket_chat`. Add variables for only the tables you want to enable/disable:

```yml
vars:
    using_audit_log:            True          #Enable if you are using audit_logs
    using_ticket_chat:          True          #Enable if you are using ticket_chat or ticket_chat_event
    using_schedules:            False         #Disable if you are not using schedules, which requires source tables ticket_schedule, daylight_time, and time_zone
    using_holidays:             False         #Disable if you are not using schedule_holidays for holidays
    using_domain_names:         False         #Disable if you are not using domain names
    using_user_tags:            False         #Disable if you are not using user tags
    using_ticket_form_history:  False         #Disable if you are not using ticket form history
    using_brands:               False         #Disable if you are not using brands
    using_organizations:        False         #Disable if you are not using organizations. Setting this to False will also disable organization tags. 
    using_organization_tags:    False         #Disable if you are not using organization tags.
```

### (Optional) Step 5: Additional configurations
<details open><summary>Collapse/Expand configurations</summary>

#### Add passthrough columns
This package includes all source columns defined in the macros folder. You can add more columns from the `TICKET`, `USER`, and `ORGANIZATION` tables using our pass-through column variables, which will persist these custom fields to the `stg_zendesk__ticket`, `stg_zendesk__user`, and `stg_zendesk__organization` models, respectively.

These variables allow for the pass-through fields to be aliased (`alias`) and casted (`transform_sql`) if desired, but not required. Datatype casting is configured via a sql snippet within the `transform_sql` key. You may add the desired sql while omitting the `as field_name` at the end and your custom pass-through fields will be casted accordingly. Use the below format for declaring the respective pass-through variables:

```yml
vars:
  zendesk__ticket_passthrough_columns:
    - name: "account_custom_field_1" # required
      alias: "account_1" # optional
      transform_sql: "cast(account_1 as string)" # optional, must reference the alias if an alias is provided (otherwise the original name)
    - name: "account_custom_field_2"
      transform_sql: "cast(account_custom_field_2 as string)"
    - name: "account_custom_field_3"
  zendesk__user_passthrough_columns:
    - name: "internal_app_id_c"
      alias: "app_id"
  zendesk__organization_passthrough_columns:
    - name: "custom_org_field_1"
```

> Note: Earlier versions of this package employed a more rudimentary format for passthrough columns, in which the user provided a list of field names to pass in, rather than a mapping. In the above `ticket` example, this would be `[account_custom_field_1, account_custom_field_2, account_custom_field_3]`.
>
> This old format will still work, as our passthrough-column macros are all backwards compatible.

#### Mark Former Internal Users as Agents
If a team member leaves your organization and their internal account is deactivated, their `USER.role` will switch from `agent` or `admin` to `end-user`. This will skew historical ticket SLA metrics, as we calculate reply times and other metrics based on `agent` or `admin` activity only.

To persist the integrity of historical ticket SLAs and mark these former team members as agents, provide the `internal_user_criteria` variable with a SQL clause to identify them, based on fields in the `USER` table. This SQL will be wrapped in a `case when` statement in the `stg_zendesk__user` model.

Example usage:
```yml
# dbt_project.yml
vars:
  zendesk_source:
    internal_user_criteria: "lower(email) like '%@fivetran.com' or external_id = '12345' or name in ('Garrett', 'Alfredo')" # can reference any non-custom field in USER
```

#### Change the build schema
By default, this package builds the zendesk staging models within a schema titled (`<target_schema>` + `_zendesk_source`) in your target database. If this is not where you would like your Zendesk Support staging data to be written to, add the following configuration to your root `dbt_project.yml` file:

```yml
models:
    zendesk_source:
      +schema: my_new_schema_name # leave blank for just the target_schema
```
    
### Change the source table references (only if using a single connection)
If an individual source table has a different name than the package expects, add the table name as it appears in your destination to the respective variable. This is not available when running the package on multiple unioned connections.
> IMPORTANT: See this project's [dbt_project.yml](https://github.com/fivetran/dbt_zendesk_source/blob/main/dbt_project.yml) variable declarations to see the expected names.
    
```yml
vars:
    zendesk_<default_source_table_name>_identifier: your_table_name 
```

#### Snowflake Users
If you do **not** use the default all-caps naming conventions for Snowflake, you may need to provide the case-sensitive spelling of your source tables that are also Snowflake reserved words.

In this package, this would apply to the `GROUP` source. If you are receiving errors for this source, include the below identifier in your `dbt_project.yml` file:

```yml
vars:
    zendesk_group_identifier: "Group" # as an example, must include the double-quotes and correct case
```  

</details>

### (Optional) Step 6: Orchestrate your models with Fivetran Transformations for dbt Core™
<details><summary>Expand to view details</summary>
<br>
    
Fivetran offers the ability for you to orchestrate your dbt project through [Fivetran Transformations for dbt Core™](https://fivetran.com/docs/transformations/dbt). Learn how to set up your project for orchestration through Fivetran in our [Transformations for dbt Core™ setup guides](https://fivetran.com/docs/transformations/dbt#setupguide).
</details>
    
## Does this package have dependencies?
This dbt package is dependent on the following dbt packages. These dependencies are installed by default within this package. For more information on the following packages, refer to the [dbt hub](https://hub.getdbt.com/) site.
> IMPORTANT: If you have any of these dependent packages in your own `packages.yml` file, we highly recommend that you remove them from your root `packages.yml` to avoid package version conflicts.
```yml
packages:
    - package: fivetran/fivetran_utils
      version: [">=0.4.0", "<0.5.0"]

    - package: dbt-labs/dbt_utils
      version: [">=1.0.0", "<2.0.0"]

    - package: dbt-labs/spark_utils
      version: [">=0.3.0", "<0.4.0"]
```
          
## How is this package maintained and can I contribute?
### Package Maintenance
The Fivetran team maintaining this package _only_ maintains the latest version of the package. We highly recommend that you stay consistent with the [latest version](https://hub.getdbt.com/fivetran/zendesk_source/latest/) of the package and refer to the [CHANGELOG](https://github.com/fivetran/dbt_zendesk_source/blob/main/CHANGELOG.md) and release notes for more information on changes across versions.

### Contributions
A small team of analytics engineers at Fivetran develops these dbt packages. However, the packages are made better by community contributions.

We highly encourage and welcome contributions to this package. Check out [this dbt Discourse article](https://discourse.getdbt.com/t/contributing-to-a-dbt-package/657) to learn how to contribute to a dbt package.

## Are there any resources available?
- If you have questions or want to reach out for help, see the [GitHub Issue](https://github.com/fivetran/dbt_zendesk_source/issues/new/choose) section to find the right avenue of support for you.
- If you would like to provide feedback to the dbt package team at Fivetran or would like to request a new dbt package, fill out our [Feedback Form](https://www.surveymonkey.com/r/DQ7K7WW).
