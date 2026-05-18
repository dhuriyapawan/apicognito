#!/usr/bin/env bash
set -euo pipefail

echo "🚀 Starting safe Terraform bootstrap import..."

cd terraform

# -------------------------
# DynamoDB
# -------------------------
TABLE="cloudguard-violations"

if aws dynamodb describe-table --table-name "$TABLE" >/dev/null 2>&1; then
  echo "Importing DynamoDB..."
  terraform import aws_dynamodb_table.violations "$TABLE" || true
fi

# -------------------------
# Lambda
# -------------------------
LAMBDA="cloudguard-handler"

if aws lambda get-function --function-name "$LAMBDA" >/dev/null 2>&1; then
  echo "Importing Lambda..."
  terraform import aws_lambda_function.violation_handler "$LAMBDA" || true
fi

# -------------------------
# S3
# -------------------------
BUCKET="cloudguard-config-bucket"

if aws s3api head-bucket --bucket "$BUCKET" 2>/dev/null; then
  echo "Importing S3 bucket..."
  terraform import aws_s3_bucket.config_bucket "$BUCKET" || true
fi

# -------------------------
# IAM Role
# -------------------------
ROLE="cloudguard-lambda-role"

if aws iam get-role --role-name "$ROLE" >/dev/null 2>&1; then
  echo "Importing IAM Role..."
  terraform import aws_iam_role.lambda_role "$ROLE" || true
fi

echo "✅ Import bootstrap completed"