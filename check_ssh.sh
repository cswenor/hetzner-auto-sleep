#!/bin/bash

# Configuration
LOG_FILE="/var/log/ssh_check.log"
IDLE_COUNTER_FILE="/tmp/idle_count"
MAX_IDLE_COUNT=2
MAX_LOG_SIZE=1048576

# Truncate log file if needed
if [ -f "$LOG_FILE" ] && [ $(stat -c%s "$LOG_FILE") -gt $MAX_LOG_SIZE ]; then
  echo "$(date): Log file exceeded $MAX_LOG_SIZE bytes. Truncating." > "$LOG_FILE"
fi

# Validate active SSH connections
ACTIVE=$(ss -tan state established '( sport = :22 )' -H | awk '{print $NF}' | sed 's/.*::ffff://g' | sed 's/\]//g' | cut -d: -f1 | sort | uniq | wc -l)

# Check if connections have activity
VALID_ACTIVE=0
if [ "$ACTIVE" -gt 0 ]; then
  while read -r IP; do
    # Check if the connection has had recent activity (recv/send queue non-zero)
    CHECK=$(ss -tan state established '( sport = :22 )' -H | grep "$IP" | awk '{print $2, $3}' | grep -E '[1-9]')
    if [ -n "$CHECK" ]; then
      VALID_ACTIVE=$((VALID_ACTIVE + 1))
    fi
  done <<< "$(ss -tan state established '( sport = :22 )' -H | awk '{print $NF}' | sed 's/.*::ffff://g' | sed 's/\]//g' | cut -d: -f1 | sort | uniq)"
fi

# Log the validated connections
echo "$(date): Valid active SSH connections: $VALID_ACTIVE" >> "$LOG_FILE"

# Idle detection logic
if [ "$VALID_ACTIVE" -eq 0 ]; then
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
  echo "$(date): SSH sessions detected. Resetting idle counter." >> "$LOG_FILE"
  echo 0 > "$IDLE_COUNTER_FILE"
  exit 1
fi
