import requests
import json
import os
from slack_sdk.webhook import WebhookClient
# https://docs.aws.amazon.com/AmazonCloudWatch/latest/APIReference/API_MetricAlarm.html
# https://api.slack.com/reference/messaging/attachments


def lambda_handler(event, context):
  print(event)
  print(json.dumps(event))
  webhook = WebhookClient(os.environ['SLACK_WEBHOOK'])
  for record in event['Records']:
    if record['EventSource'] == "aws:sns":
      notification = record['Sns']
      subject = notification['Subject']
      message = json.loads(notification['Message'])
      name = message['AlarmName']
      desc = message['AlarmDescription']
      status = message['NewStateValue']
      l_status = message['OldStateValue']
      time_of_change = message['StateChangeTime']
      stat_type = message['Trigger']['Statistic']
      dims = message['Trigger']['Dimensions']
      if status == "ALARM":
        color = "#fc0a0a"
      else:
        color = "#22fc0a"
      response = webhook.send(attachments=[{"color": color, 
                                            "title": subject, 
                                            "text" : desc,
                                            "fields": [
                                              {
                                                "title": "Aler dimensions",
                                                "short": False,
                                                "value": "\n".join([f'{i["name"]}: {i["value"]}' for i in dims])
                                              },
                                              {
                                                "title": "Aler time",
                                                "short": True,
                                                "value": time_of_change
                                              }
                                            ]}])
    else:
      print(record)
      print("Failed to send notification")
  
  return {
      'statusCode': 200,
      'body': json.dumps({"Status": "ok"})
  }
