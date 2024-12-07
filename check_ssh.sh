#!/bin/bash

# Configuration
LOG_FILE="/var/log/ssh_check.log"      # Log file location
IDLE_COUNTER_FILE="/tmp/idle_count"   # File to store idle count
MAX_IDLE_COUNT=2                      # Number of idle checks before shutdown
MAX_LOG_SIZE=1048576                  # Maximum log size (1MB in bytes)

# Ensure log directory exists
mkdir -p "$(dirname "$LOG_FILE")"

# Truncate the log file if it exceeds the max size
if [ -f "$LOG_FILE" ] && [ $(stat -c%s "$LOG_FILE") -gt $MAX_LOG_SIZE ]; then
  echo "$(date): Log file exceeded $MAX_LOG_SIZE bytes. Truncating." > "$LOG_FILE"
fi

# Count active SSH connections by filtering unique IPs
ACTIVE=$(ss -tn state established '( sport = :22 )' -H | awk '{print $NF}' | sed 's/.*::ffff://g' | sed 's/\]//g' | cut -d: -f1 | sort | uniq | wc -l)

# Log the current SSH session count
echo "$(date): Active SSH connections: $ACTIVE" >> "$LOG_FILE"

# Check if there are active SSH connections
if [ "$ACTIVE" -eq 0 ]; then
  # Increment idle counter
  IDLE_COUNT=$(cat "$IDLE_COUNTER_FILE" 2>/dev/null || echo 0)
  IDLE_COUNT=$((IDLE_COUNT + 1))
  echo "$IDLE_COUNT" > "$IDLE_COUNTER_FILE"

  if [ "$IDLE_COUNT" -ge "$MAX_IDLE_COUNT" ]; then
    echo "$(date): Server idle for too long. Proceeding to shutdown." >> "$LOG_FILE"
    exit 0  # Indicate idle state for shutdown
  else
    echo "$(date): Server idle. Waiting for more intervals." >> "$LOG_FILE"
    exit 1  # Indicate idle, but not ready to shut down
  fi
else
  # Reset idle counter if SSH is active
  echo "$(date): SSH sessions detected. Resetting idle counter." >> "$LOG_FILE"
  echo 0 > "$IDLE_COUNTER_FILE"
  exit 1  # Indicate busy state
fi
