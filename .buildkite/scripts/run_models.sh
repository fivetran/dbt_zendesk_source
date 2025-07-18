#!/bin/bash

set -euo pipefail

apt-get update
apt-get install libsasl2-dev

python3 -m venv venv
. venv/bin/activate
pip install --upgrade pip setuptools
pip install -r integration_tests/requirements.txt
mkdir -p ~/.dbt
cp integration_tests/ci/sample.profiles.yml ~/.dbt/profiles.yml

db=$1
echo `pwd`
cd integration_tests
dbt deps
dbt seed --target "$db" --full-refresh
dbt source freshness --target "$db" || echo "...Only verifying freshness runs..."
dbt run --target "$db" --full-refresh
dbt test --target "$db"
dbt run --vars '{using_schedules: false, using_domain_names: false, using_user_tags: false, using_ticket_form_history: false, using_organization_tags: false, using_organizations: false, using_brands: false}' --target "$db" --full-refresh
dbt test --target "$db"
dbt run --vars '{using_audit_log: true, using_holidays: false, using_ticket_chat: true}' --target "$db" --full-refresh
dbt test --target "$db"
dbt run-operation fivetran_utils.drop_schemas_automation --target "$db"
