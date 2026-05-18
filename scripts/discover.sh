#!/usr/bin/env bash
set -euo pipefail

echo "🔍 Discovering existing AWS resources..."

cd terraform

# ---------------------------
# Lambda
# ---------------------------
LAMBDA="cloudguard-handler"

if aws lambda get-function --function-name "$LAMBDA" >/dev/null 2>&1; then
  echo "📦 Importing Lambda if needed..."
  terraform import aws_lambda_function.violation_handler "$LAMBDA" || true
fi

# ---------------------------
# IAM Policy
# ---------------------------
POLICY_ARN=$(aws iam list-policies \
  --query "Policies[?PolicyName=='cloudguard-policy'].Arn" \
  --output text)

if [[ -n "$POLICY_ARN" ]]; then
  echo "📦 Importing IAM policy..."
  terraform import aws_iam_policy.custom_policy "$POLICY_ARN" || true
fi

# ---------------------------
# S3 (GLOBAL SAFE CHECK)
# ---------------------------
BUCKET="cloudguard-config-buckets"

if aws s3api head-bucket --bucket "$BUCKET" 2>/dev/null; then
  echo "📦 Importing S3 bucket..."
  terraform import aws_s3_bucket.config_bucket "$BUCKET" || true
fi

echo "✅ Discovery complete"