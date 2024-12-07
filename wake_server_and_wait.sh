#!/bin/bash

SCRIPT_DIR=$(dirname "$(readlink -f "$0")")

# Load the .env file from the script's directory
if [ -f "$SCRIPT_DIR/.env" ]; then
  export $(grep -v '^#' "$SCRIPT_DIR/.env" | xargs)
else
  echo "Error: .env file not found in $SCRIPT_DIR"
  exit 1
fi

# Ensure required environment variables are set
if [[ -z "$HETZNER_API_TOKEN" || -z "$HETZNER_SERVER_ID" ]]; then
  echo "Error: HETZNER_API_TOKEN or HETZNER_SERVER_ID is not set."
  exit 1
fi

# Wake the server
echo "Waking the server..."
curl -X POST "https://api.hetzner.cloud/v1/servers/$HETZNER_SERVER_ID/actions/poweron" \
     -H "Authorization: Bearer $HETZNER_API_TOKEN" \
     -H "Content-Type: application/json"

# Wait for the server to be ready
echo "Waiting for the server to start..."
sleep 30  # Adjust this based on your server's average boot time

exit 0  # Exit cleanly to allow VS Code to proceed with the connection
