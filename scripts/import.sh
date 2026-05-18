#!/usr/bin/env bash
set -euo pipefail

TABLE="cloudguard-violations"

echo "Checking DynamoDB table..."

if aws dynamodb describe-table --table-name "$TABLE" >/dev/null 2>&1; then
  echo "Table exists → importing into Terraform state"

  terraform -chdir=terraform import aws_dynamodb_table.violations "$TABLE" || true
else
  echo "Table does not exist → Terraform will create it"
fi