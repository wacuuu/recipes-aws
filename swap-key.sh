#!/bin/bash
set -xe

OLD_KEY_ID=$(aws iam list-access-keys --output json | jq '.AccessKeyMetadata[0].AccessKeyId' | sed 's%"%%g')

NEW_KEY_JSON="$(aws iam create-access-key --output json)"
NEW_KEY_ID="$(echo "$NEW_KEY_JSON" | jq '.AccessKey.AccessKeyId' | sed 's%"%%g')"
NEW_SECRET_KEY="$(echo "$NEW_KEY_JSON" | jq '.AccessKey.SecretAccessKey' | sed 's%"%%g')"

cat >~/.aws/credentials <<EOF
[default]
aws_access_key_id = $NEW_KEY_ID
aws_secret_access_key = $NEW_SECRET_KEY
EOF
sleep 15
aws iam delete-access-key --access-key-id "$OLD_KEY_ID"
