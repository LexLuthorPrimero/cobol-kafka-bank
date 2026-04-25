#!/usr/bin/env bash
set -euo pipefail

echo "=== FAIR SCHEDULER ==="

QUEUES=("A" "B" "C")

while true; do

  for Q in "${QUEUES[@]}"; do

    FILE="accounts/queues/$Q.queue"

    if [ -s "$FILE" ]; then
      read -r EVENT < "$FILE"
      sed -i '1d' "$FILE"

      echo "[PROCESS] USER=$Q EVENT=$EVENT"
      ./apply_event_once.sh "$EVENT" "$Q" "100"

    fi

  done

  sleep 0.2

done
