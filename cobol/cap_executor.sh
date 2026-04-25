#!/usr/bin/env bash
set -euo pipefail

echo "=== CAP EXECUTOR ==="

MODE=$(cat accounts/CAP_MODE.state 2>/dev/null || echo "BALANCED")

echo "ACTIVE MODE: $MODE"

for Q in A B C; do

  FILE="accounts/queues/$Q.queue"

  if [ ! -s "$FILE" ]; then
    continue
  fi

  read -r EVENT < "$FILE"
  sed -i '1d' "$FILE"

  case "$MODE" in

    CONSISTENCY)
      echo "[STRICT APPLY] $EVENT"
      ./apply_event_once.sh "$EVENT" "$Q" "100"
      ;;

    BALANCED)
      echo "[NORMAL APPLY] $EVENT"
      ./apply_event_once.sh "$EVENT" "$Q" "80"
      ;;

    AVAILABILITY)
      echo "[FAST APPLY] $EVENT (relaxed consistency)"
      ./apply_event_once.sh "$EVENT" "$Q" "50"
      ;;

  esac

done
