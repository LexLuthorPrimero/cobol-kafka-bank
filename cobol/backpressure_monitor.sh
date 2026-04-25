#!/usr/bin/env bash
set -euo pipefail

echo "=== BACKPRESSURE MONITOR ==="

THRESHOLD_HIGH=20
THRESHOLD_MED=10

TOTAL_QUEUE_SIZE=0

for Q in A B C; do
  SIZE=$(wc -l < "accounts/queues/$Q.queue" 2>/dev/null || echo 0)
  TOTAL_QUEUE_SIZE=$((TOTAL_QUEUE_SIZE + SIZE))
done

echo "TOTAL_QUEUE_SIZE=$TOTAL_QUEUE_SIZE"

if [ "$TOTAL_QUEUE_SIZE" -gt "$THRESHOLD_HIGH" ]; then
  echo "[BACKPRESSURE] HIGH → REJECT MODE"
  exit 2
fi

if [ "$TOTAL_QUEUE_SIZE" -gt "$THRESHOLD_MED" ]; then
  echo "[BACKPRESSURE] MED → THROTTLE MODE"
  exit 1
fi

echo "[OK] NORMAL LOAD"
