#!/bin/bash

# Check if jq is installed
if ! command -v jq &> /dev/null; then
    echo "jq is not installed. Please install jq to use this script."
    exit 1
fi

# JSON input file
json_file="config.json"

# Check if the email array is not empty
if [ $(jq -r '.email | length' "$json_file") -eq 0 ]; then
    echo "Email array is empty."
    exit 1
fi

# Check if the Splunk index is not empty
if [ -z $(jq -r '.splunk_index' "$json_file") ]; then
    echo "Splunk index is empty."
    exit 1
fi

# Validate the JSON error codes if enable_all is false
if [ $(jq -r '.error_codes.enable_all' "$json_file") == "false" ]; then
    if jq -e '.error_codes.codes | all(. == 400 or . == 401 or . == 500)' "$json_file"; then
        echo "JSON validation successful. It contains only allowed status codes (400 and 401 and 500)."
    else
        echo "JSON validation failed. It contains disallowed status codes."
        exit 1
    fi
else
    echo "JSON validation skipped for error codes. enable_all is set to true."
fi

# Check if the business alerts array has a specific size (e.g., 1)
if [ $(jq -r '.business_alerts | length' "$json_file") -ne 0 ]; then
    echo "Business alerts present"
fi
exit 0
