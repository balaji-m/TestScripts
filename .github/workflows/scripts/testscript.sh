#!/bin/bash

# Check if jq is installed
if ! command -v jq &> /dev/null; then
    echo "jq is not installed. Please install jq to use this script."
    exit 1
fi

# JSON input file
json_file="config.json"

# Validate the JSON and allow only codes 400 and 401
if jq -e '.error_codes.codes | all(. == 400 or . == 401)' "$json_file"; then
    echo "JSON validation successful. It contains only allowed status codes (400 and 401)."
    exit 0
else
    echo "JSON validation failed. It contains disallowed status codes."
    exit 1
fi
