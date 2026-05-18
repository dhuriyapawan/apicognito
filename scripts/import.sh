#!/bin/bash
set -e
TABLE = "cloudguard-violations"

echo "Checking if DynamoDB tabele Exists.."

aws dynamodb describe-table \
    --table-name $TABLE >/dev/null 2>&1

if [&? -eq 0 ]; then

    echo "Table exists.Importing inot terraform state .."
    terraform import aws_dynamodb-table.violations $TABLE || true

else
    echo "Table does not exist.Terraform will create i"

fi 
