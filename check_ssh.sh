#!/bin/bash

# Configuration
LOG_FILE="/var/log/ssh_check.log"
IDLE_COUNTER_FILE="/tmp/idle_count"
MAX_IDLE_COUNT=2
MAX_LOG_SIZE=1048576

# Count active SSH sessions with no idle time
ACTIVE=$(who -u | awk '{if ($5 == ".") print $0}' | wc -l)

# Log the validated connections
echo "$(date): Active SSH sessions: $ACTIVE" >> "$LOG_FILE"

if [ "$ACTIVE" -eq 0 ]; then
  # Increment idle counter
  IDLE_COUNT=$(cat "$IDLE_COUNTER_FILE" 2>/dev/null || echo 0)
  IDLE_COUNT=$((IDLE_COUNT + 1))
  echo "$IDLE_COUNT" > "$IDLE_COUNTER_FILE"

  if [ "$IDLE_COUNT" -ge "$MAX_IDLE_COUNT" ]; then
    echo "$(date): Server idle for too long. Proceeding to shutdown." >> "$LOG_FILE"
    exit 0
  else
    echo "$(date): Server idle. Waiting for more intervals." >> "$LOG_FILE"
    exit 1
  fi
else
  # Reset idle counter if SSH is active
  echo "$(date): SSH sessions detected. Resetting idle counter." >> "$LOG_FILE"
  echo 0 > "$IDLE_COUNTER_FILE"
  exit 1
fi
