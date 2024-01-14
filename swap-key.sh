#!/bin/bash
set -xe

OLD_KEY_ID=$(aws iam --profile "${AWS_PROFILE:-default}" list-access-keys --output json | jq '.AccessKeyMetadata[0].AccessKeyId' | sed 's%"%%g')

NEW_KEY_JSON="$(aws iam create-access-key --output json)"
NEW_KEY_ID="$(echo "$NEW_KEY_JSON" | jq '.AccessKey.AccessKeyId' | sed 's%"%%g')"
NEW_SECRET_KEY="$(echo "$NEW_KEY_JSON" | jq '.AccessKey.SecretAccessKey' | sed 's%"%%g')"

aws configure --profile "${AWS_PROFILE:-default}" set aws_access_key_id $NEW_KEY_ID
aws configure --profile "${AWS_PROFILE:-default}" set aws_secret_access_key $NEW_SECRET_KEY

sleep 15
aws iam --profile "${AWS_PROFILE:-default}" delete-access-key --access-key-id "$OLD_KEY_ID"
