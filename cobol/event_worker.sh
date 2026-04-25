#!/usr/bin/env bash
set -euo pipefail

QUEUE="accounts/EVENT_QUEUE.tmp"
STATE_FILE="accounts/STATE.tmp"

echo "=== WORKER START ==="

SALDO=10000

while IFS= read -r line; do

  IFS='|' read -r VERSION STATUS ACC_ID AMOUNT <<< "$line"

  if [ "$STATUS" != "OK" ]; then
    continue
  fi

  if [ "$ACC_ID" = "00001" ]; then
    SALDO=$((SALDO - AMOUNT))
  fi

done < "$QUEUE"

echo "00001|$SALDO" > "$STATE_FILE"

echo "[OK] WORKER DONE"
