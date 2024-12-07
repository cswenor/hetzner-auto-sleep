#!/bin/bash

# Load environment variables from .env if it exists
if [ -f .env ]; then
  export $(grep -v '^#' .env | xargs)
fi

# Ensure required environment variables are set
if [[ -z "$HETZNER_API_TOKEN" || -z "$HETZNER_SERVER_ID" ]]; then
  echo "Error: HETZNER_API_TOKEN or HETZNER_SERVER_ID is not set."
  exit 1
fi

curl -X POST "https://api.hetzner.cloud/v1/servers/$HETZNER_SERVER_ID/actions/poweroff" \
     -H "Authorization: Bearer $HETZNER_API_TOKEN" \
     -H "Content-Type: application/json"
