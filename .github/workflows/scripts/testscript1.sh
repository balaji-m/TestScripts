#!/bin/bash

# Check if jq is installed
sudo snap install yq

# Update the reponame in the YAML file
yq eval '.repometadata.reponame = "qarepo"' -i asset.yml
