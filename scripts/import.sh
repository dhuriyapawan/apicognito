#!/usr/bin/env bash
set -euo pipefail

echo "Starting Terraform import bootstrap..."

# ---------------------------
# DynamoDB
# ---------------------------
TABLE="cloudguard-violations"

if aws dynamodb describe-table --table-name "$TABLE" >/dev/null 2>&1; then
  echo "Importing DynamoDB..."
  terraform -chdir=terraform import aws_dynamodb_table.violations "$TABLE" || true
fi

# ---------------------------
# IAM Role
# ---------------------------
ROLE="cloudguard-lambda-role"

if aws iam get-role --role-name "$ROLE" >/dev/null 2>&1; then
  echo "Importing IAM Role..."
  terraform -chdir=terraform import aws_iam_role.lambda_role "$ROLE" || true
fi

# ---------------------------
# IAM Policy
# ---------------------------
POLICY_NAME="cloudguard-policy"

POLICY_ARN=$(aws iam list-policies \
  --query "Policies[?PolicyName=='$POLICY_NAME'].Arn" \
  --output text)

if [[ -n "$POLICY_ARN" ]]; then
  echo "Importing IAM Policy..."
  terraform -chdir=terraform import aws_iam_policy.custom_policy "$POLICY_ARN" || true
fi

# ---------------------------
# S3 Bucket
# ---------------------------
BUCKET="cloudguard-config-bucket"

if aws s3api head-bucket --bucket "$BUCKET" 2>/dev/null; then
  echo "Importing S3 bucket..."
  terraform -chdir=terraform import aws_s3_bucket.config_bucket "$BUCKET" || true
fi

echo "Import completed."