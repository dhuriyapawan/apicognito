import json
import boto3
import os
import uuid

dynamodb = boto3.resource('dynamodb')
sns = boto3.client('sns')

TABLE_NAME = os.environ['TABLE_NAME']
TOPIC_ARN = os.environ['TOPIC_ARN']

table = dynamodb.Table(TABLE_NAME)

def handler(event, context):
    print("Event received:", event)

    violation_id = str(uuid.uuid4())

    table.put_item(
        Item={
            "id": violation_id,
            "event": json.dumps(event)
        }
    )

    sns.publish(
        TopicArn=TOPIC_ARN,
        Message="Security violation detected",
        Subject="CloudGuard Alert"
    )

    return {
        "statusCode": 200,
        "body": json.dumps("Processed")
    }