#!/usr/bin/env bash
set -euo pipefail

JOURNAL="accounts/JOURNAL.LOG"
QUEUE="accounts/EVENT_QUEUE.tmp"

echo "=== BUILDING EVENT QUEUE ==="

> "$QUEUE"

while IFS= read -r line; do
  echo "$line" >> "$QUEUE"
done < "$JOURNAL"

echo "[OK] QUEUE READY"
