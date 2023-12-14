import requests
import json
import os
from slack_sdk.webhook import WebhookClient
# https://docs.aws.amazon.com/AmazonCloudWatch/latest/APIReference/API_MetricAlarm.html


def lambda_handler(event, context):
  alert_message = json.loads(json.dumps(event))["Records"][0]["Sns"]["Message"]
  webhook = os.environ['SLACK_WEBHOOK']
  webhook = WebhookClient(webhook)

  response = webhook.send(text="Hello!")
  response = webhook.send(text=alert_message)
  # print(alert_message)
  # print(event)
  # print(event)
  return {

      'statusCode': 200,
      'body': json.dumps(alert_message)
  }





