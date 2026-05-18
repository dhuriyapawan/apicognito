#!/usr/bin/env bash
set -euo pipefail

TABLE="cloudguard-violations"

echo "Checking DynamoDB table: $TABLE"

if aws dynamodb describe-table --table-name "$TABLE" >/dev/null 2>&1; then
  echo "Table exists → importing into Terraform state"

  terraform import aws_dynamodb_table.violations "$TABLE" || true
else
  echo "Table not found → Terraform will create it"
fi