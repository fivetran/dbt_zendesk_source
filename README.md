<p align="center">
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

# Zendesk Support Source dbt Package ([Docs](https://fivetran.github.io/dbt_zendesk_source/))
# 📣 What does this dbt package do?
<!--section="zendesk_source_model"-->
- Materializes [Zendesk Support staging tables](https://fivetran.github.io/dbt_github_source/#!/overview/zendesk_source/models/?g_v=1) which leverage data in the format described by [this ERD](https://fivetran.com/docs/applications/zendesk#schemainformation). These staging tables clean, test, and prepare your Zendesk Support data from [Fivetran's connector](https://fivetran.com/docs/applications/zendesk) for analysis by doing the following:
  - Name columns for consistency across all packages and for easier analysis
  - Adds freshness tests to source data
  - Adds column-level testing where applicable. For example, all primary keys are tested for uniqueness and non-null values.
- Generates a comprehensive data dictionary of your Zendesk Support data through the [dbt docs site](https://fivetran.github.io/dbt_zendesk_source/).
- These tables are designed to work simultaneously with our [Zendesk Support transformation package](https://github.com/fivetran/dbt_zendesk).
<!--section-end-->

# 🎯 How do I use the dbt package?
## Step 1: Prerequisites
To use this dbt package, you must have the following:
- A Fivetran Zendesk Support connector syncing data into your destination. 
- A **BigQuery**, **Snowflake**, **Redshift**, **PostgreSQL**, or **Databricks** destination.

### Databricks Dispatch Configuration
If you are using a Databricks destination with this package you will need to add the below (or a variation of the below) dispatch configuration within your `dbt_project.yml`. This is required in order for the package to accurately search for macros within the `dbt-labs/spark_utils` then the `dbt-labs/dbt_utils` packages respectively.
```yml
dispatch:
  - macro_namespace: dbt_utils
    search_order: ['spark_utils', 'dbt_utils']
```

## Step 2: Install the package
Include the following zendesk_source package version in your `packages.yml` file **only if you are NOT also installing the [Zendesk Support transformation package](https://github.com/fivetran/dbt_zendesk)**. The transform package has a dependency on this source package.
> TIP: Check [dbt Hub](https://hub.getdbt.com/) for the latest installation instructions or [read the dbt docs](https://docs.getdbt.com/docs/package-management) for more information on installing packages.
```yaml
packages:
  - package: fivetran/zendesk_source
    version: [">=0.11.0", "<0.12.0"]
```
## Step 3: Define database and schema variables
By default, this package runs using your target database and the `zendesk` schema. If this is not where your Zendesk Support data is (for example, if your zendesk schema is named `zendesk_fivetran`), add the following configuration to your root `dbt_project.yml` file:

```yml
vars:
    zendesk_database: your_destination_name
    zendesk_schema: your_schema_name 
```
## Step 4: Disable models for non-existent sources
This package takes into consideration that not every Zendesk Support account utilizes the `schedule`, `domain_name`, `user_tag`, `organization_tag`, or `ticket_form_history` features, and allows you to disable the corresponding functionality. By default, all variables' values are assumed to be `true`. Add variables for only the tables you want to disable:
```yml
vars:
    using_schedules:            False         #Disable if you are not using schedules
    using_domain_names:         False         #Disable if you are not using domain names
    using_user_tags:            False         #Disable if you are not using user tags
    using_ticket_form_history:  False         #Disable if you are not using ticket form history
    using_organization_tags:    False         #Disable if you are not using organization tags
```

## (Optional) Step 5: Additional configurations

### Add passthrough columns
This package includes all source columns defined in the staging models. However, the `stg_zendesk__ticket` model allows for additional columns to be added using a pass-through column variable. This is extremely useful if you'd like to include custom fields to the package.
```yml
vars:
  zendesk__ticket_passthrough_columns: [account_custom_field_1, account_custom_field_2]
```

### Mark Former Internal Users as Agents
If a team member leaves your organization and their internal account is deactivated, their `USER.role` will switch from `agent` or `admin` to `end-user`. This will skew historical ticket SLA metrics, as we calculate reply times and other metrics based on `agent` or `admin` activity only.

To persist the integrity of historical ticket SLAs and mark these former team members as agents, provide the `internal_user_criteria` variable with a SQL clause to identify them, based on fields in the `USER` table. This SQL will be wrapped in a `case when` statement in the `stg_zendesk__user` model.

Example usage:
```yml
# dbt_project.yml
vars:
  zendesk_source:
    internal_user_criteria: "lower(email) like '%@fivetran.com' or external_id = '12345' or name in ('Garrett', 'Alfredo')" # can reference any non-custom field in USER
```

### Change the build schema
By default, this package builds the zendesk staging models within a schema titled (`<target_schema>` + `_zendesk_source`) in your target database. If this is not where you would like your Zendesk Support staging data to be written to, add the following configuration to your root `dbt_project.yml` file:

```yml
models:
    zendesk_source:
      +schema: my_new_schema_name # leave blank for just the target_schema
```
    
### Change the source table references
If an individual source table has a different name than the package expects, add the table name as it appears in your destination to the respective variable:
> IMPORTANT: See this project's [dbt_project.yml](https://github.com/fivetran/dbt_zendesk_source/blob/main/dbt_project.yml) variable declarations to see the expected names.
    
```yml
vars:
    zendesk_<default_source_table_name>_identifier: your_table_name 
```

### 🚨 Snowflake Users
If you do **not** use the default all-caps naming conventions for Snowflake, you may need to provide the case-sensitive spelling of your source tables that are also Snowflake reserved words. 

In this package, this would apply to the `GROUP` source. If you are receiving errors for this source, include the below identifier in your `dbt_project.yml` file:

```yml
vars:
    zendesk_group_identifier: "Group" # as an example, must include the double-quotes and correct case!
```  


## (Optional) Step 6: Orchestrate your models with Fivetran Transformations for dbt Core™
<details><summary>Expand to view details</summary>
<br>
    
Fivetran offers the ability for you to orchestrate your dbt project through [Fivetran Transformations for dbt Core™](https://fivetran.com/docs/transformations/dbt). Learn how to set up your project for orchestration through Fivetran in our [Transformations for dbt Core™ setup guides](https://fivetran.com/docs/transformations/dbt#setupguide).
</details>
    
# 🔍 Does this package have dependencies?
This dbt package is dependent on the following dbt packages. Please be aware that these dependencies are installed by default within this package. For more information on the following packages, refer to the [dbt hub](https://hub.getdbt.com/) site.
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
          
# 🙌 How is this package maintained and can I contribute?
## Package Maintenance
The Fivetran team maintaining this package _only_ maintains the latest version of the package. We highly recommend that you stay consistent with the [latest version](https://hub.getdbt.com/fivetran/zendesk_source/latest/) of the package and refer to the [CHANGELOG](https://github.com/fivetran/dbt_zendesk_source/blob/main/CHANGELOG.md) and release notes for more information on changes across versions.

## Contributions
A small team of analytics engineers at Fivetran develops these dbt packages. However, the packages are made better by community contributions! 

We highly encourage and welcome contributions to this package. Check out [this dbt Discourse article](https://discourse.getdbt.com/t/contributing-to-a-dbt-package/657) to learn how to contribute to a dbt package!

# 🏪 Are there any resources available?
- If you have questions or want to reach out for help, please refer to the [GitHub Issue](https://github.com/fivetran/dbt_zendesk_source/issues/new/choose) section to find the right avenue of support for you.
- If you would like to provide feedback to the dbt package team at Fivetran or would like to request a new dbt package, fill out our [Feedback Form](https://www.surveymonkey.com/r/DQ7K7WW).
- Have questions or want to be part of the community discourse? Create a post in the [Fivetran community](https://community.fivetran.com/t5/user-group-for-dbt/gh-p/dbt-user-group) and our team along with the community can join in on the discussion!
