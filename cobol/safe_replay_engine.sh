#!/usr/bin/env bash
set -euo pipefail

echo "=== SAFE REPLAY ENGINE (IDEMPOTENT) ==="

while read -r EVENT STATUS ID AMOUNT; do

  if [ "$STATUS" != "OK" ]; then
    continue
  fi

  ./apply_event_once.sh "$EVENT" "$ID" "$AMOUNT"

done < accounts/JOURNAL.LOG

echo "[OK] REPLAY COMPLETE WITHOUT DUPLICATES"
