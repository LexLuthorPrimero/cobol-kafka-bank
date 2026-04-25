#!/usr/bin/env bash
set -euo pipefail

echo "=== CAP MODE CONTROLLER ==="

QUEUE_SIZE=$(wc -l < accounts/queues/A.queue 2>/dev/null || echo 0)
QUEUE_SIZE=$((QUEUE_SIZE + $(wc -l < accounts/queues/B.queue 2>/dev/null || echo 0)))
QUEUE_SIZE=$((QUEUE_SIZE + $(wc -l < accounts/queues/C.queue 2>/dev/null || echo 0)))

echo "QUEUE_SIZE=$QUEUE_SIZE"

if [ "$QUEUE_SIZE" -lt 10 ]; then
  MODE="CONSISTENCY"
elif [ "$QUEUE_SIZE" -lt 50 ]; then
  MODE="BALANCED"
else
  MODE="AVAILABILITY"
fi

echo "[MODE] $MODE"
echo "$MODE" > accounts/CAP_MODE.state
