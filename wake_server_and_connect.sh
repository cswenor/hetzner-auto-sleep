#!/bin/bash

# Load environment variables from .env if it exists
if [ -f .env ]; then
  export $(grep -v '^#' .env | xargs)
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
sleep 30

# Connect to the server
echo "Connecting to the server..."
ssh "$HETZNER_CONNECTION_STRING"
