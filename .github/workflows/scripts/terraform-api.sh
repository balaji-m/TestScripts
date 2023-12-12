#!/bin/bash

# Complete script for API-driven runs.

# 1. Define Variables
tf_api_token=$1
CONTENT_DIRECTORY="tf"
ORG_NAME="MyFirstOrg-BalajiM"
WORKSPACE_NAME="MyFirstWorkspace"

echo "testing the terraform script"

# 2. Create the File for Upload

UPLOAD_FILE_NAME="./content-$(date +%s).tar.gz"
tar -zcvf "$UPLOAD_FILE_NAME" -C "$CONTENT_DIRECTORY" .

echo "step2 completed: $UPLOAD_FILE_NAME"

# 3. Look Up the Workspace ID

WORKSPACE_ID=($(curl \
  --header "Authorization: Bearer $tf_api_token" \
  --header "Content-Type: application/vnd.api+json" \
  https://app.terraform.io/api/v2/organizations/$ORG_NAME/workspaces/$WORKSPACE_NAME \
  | jq -r '.data.id'))

# # 4. Create a New Configuration Version

echo '{"data":{"type":"configuration-versions"}}' > ./create_config_version.json

UPLOAD_URL=($(curl \
  --header "Authorization: Bearer $tf_api_token" \
  --header "Content-Type: application/vnd.api+json" \
  --request POST \
  --data @create_config_version.json \
  https://app.terraform.io/api/v2/workspaces/$WORKSPACE_ID/configuration-versions \
  | jq -r '.data.attributes."upload-url"'))

  echo "step4 completed: $UPLOAD_URL"

# 5. Upload the Configuration Content File

curl \
  --header "Content-Type: application/octet-stream" \
  --request PUT \
  --data-binary @"$UPLOAD_FILE_NAME" \
  $UPLOAD_URL

 echo "step5 completed"

# 6. Delete Temporary Files

rm "$UPLOAD_FILE_NAME"
rm ./create_config_version.json
