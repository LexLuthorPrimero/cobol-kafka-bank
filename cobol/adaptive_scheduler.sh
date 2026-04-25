#!/usr/bin/env bash
set -euo pipefail

echo "=== ADAPTIVE SCHEDULER ==="

while true; do

  ./backpressure_monitor.sh
  STATUS=$?

  if [ "$STATUS" -eq 2 ]; then
    echo "[DROP] SYSTEM OVERLOADED"
    sleep 1
    continue
  fi

  if [ "$STATUS" -eq 1 ]; then
    SLEEP_TIME=1
  else
    SLEEP_TIME=0.2
  fi

  for Q in A B C; do
    FILE="accounts/queues/$Q.queue"

    if [ -s "$FILE" ]; then
      read -r EVENT < "$FILE"
      sed -i '1d' "$FILE"

      echo "[PROCESS] $Q → $EVENT"
      ./apply_event_once.sh "$EVENT" "$Q" "100"
    fi

  done

  sleep "$SLEEP_TIME"

done
