#!/bin/bash

# Load environment variables from .env if it exists
SCRIPT_DIR=$(dirname "$(readlink -f "$0")")

# Load the .env file from the script's directory
if [ -f "$SCRIPT_DIR/.env" ]; then
  export $(grep -v '^#' "$SCRIPT_DIR/.env" | xargs)
else
  echo "Error: .env file not found in $SCRIPT_DIR"
  exit 1
fi

# Ensure required environment variables are set
if [[ -z "$HETZNER_API_TOKEN" || -z "$HETZNER_SERVER_ID" || -z "$HETZNER_CONNECTION_STRING" ]]; then
  echo "Error: Environment variables are not set."
  exit 1
fi

# Power on the server
echo "Waking the server..."
./power_on.sh

# Wait for the server to boot
echo "Waiting for the server to start..."
sleep 15

# Connect to the server
echo "Connecting to the server..."
ssh "$HETZNER_CONNECTION_STRING"
