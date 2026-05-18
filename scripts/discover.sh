#!/usr/bin/env bash
set -euo pipefail

echo "🔍 Starting enterprise resource discovery..."

cd terraform

# ---------------------------------------------------
# Helper function
# ---------------------------------------------------
safe_import () {
  local resource=$1
  local identifier=$2

  echo "→ Importing: $resource"

  terraform state list | grep -q "^${resource}$" \
    && echo "✔ Already managed: $resource" \
    || terraform import "$resource" "$identifier" || true
}

# ---------------------------------------------------
# DynamoDB
# ---------------------------------------------------
TABLE="cloudguard-violations"

if aws dynamodb describe-table \
  --table-name "$TABLE" >/dev/null 2>&1; then

  safe_import \
    "aws_dynamodb_table.violations" \
    "$TABLE"
fi

# ---------------------------------------------------
# IAM ROLE
# ---------------------------------------------------
ROLE="cloudguard-lambda-role"

if aws iam get-role \
  --role-name "$ROLE" >/dev/null 2>&1; then

  safe_import \
    "aws_iam_role.lambda_role" \
    "$ROLE"
fi

# ---------------------------------------------------
# IAM POLICY
# ---------------------------------------------------
POLICY_ARN=$(aws iam list-policies \
  --query "Policies[?PolicyName=='cloudguard-policy'].Arn" \
  --output text)

if [[ -n "$POLICY_ARN" ]]; then

  safe_import \
    "aws_iam_policy.custom_policy" \
    "$POLICY_ARN"
fi

# ---------------------------------------------------
# LAMBDA
# ---------------------------------------------------
LAMBDA="cloudguard-handler"

if aws lambda get-function \
  --function-name "$LAMBDA" >/dev/null 2>&1; then

  safe_import \
    "aws_lambda_function.violation_handler" \
    "$LAMBDA"
fi

# ---------------------------------------------------
# S3
# ---------------------------------------------------
BUCKET="cloudguard-config-buckets"

if aws s3api head-bucket \
  --bucket "$BUCKET" 2>/dev/null; then

  safe_import \
    "aws_s3_bucket.config_bucket" \
    "$BUCKET"
fi

echo "✅ Enterprise discovery/import completed"