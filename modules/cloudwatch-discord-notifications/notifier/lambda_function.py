import json
import os
from discord_webhook import DiscordWebhook

# https://docs.aws.amazon.com/AmazonCloudWatch/latest/APIReference/API_MetricAlarm.html
# https://pypi.org/project/discord-webhook/

def lambda_handler(event, context):
    print(event)
    print(json.dumps(event, indent=4, default=str))
    for record in event["Records"]:
        if record["EventSource"] == "aws:sns":
            desc = message["AlarmDescription"]
            dims = message["Trigger"]["Dimensions"]
            l_status = message["OldStateValue"]
            message = json.loads(notification["Message"])
            name = message["AlarmName"]
            notification = record["Sns"]
            stat_type = message["Trigger"]["Statistic"]
            status = message["NewStateValue"]
            subject = notification["Subject"]
            time_of_change = message["StateChangeTime"]
            if status == "ALARM":
                color = "#fc0a0a"
                msg = f"""
**ALARM**
subject: {subject}
status change time: {time_of_change}
message: {message}
"""
            else:
                color = "#22fc0a"
                msg = f"""
**FIXED**
subject: {subject}
status change time: {time_of_change}
message: {message}
                """

            webhook = DiscordWebhook(url=os.environ["DISCORD_WEBHOOK"], content=msg)
            response = webhook.execute()
            if not response.ok:
                print(record)
                print(msg)
                print("Failed to send notification")    
                return {"statusCode": 500, "body": json.dumps({"Status": "failed to send notification"})}
        else:
            print(record)
            print("Failed to send notification")

    return {"statusCode": 200, "body": json.dumps({"Status": "ok"})}
