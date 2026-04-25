#!/usr/bin/env bash
set -euo pipefail

echo "=== OBSERVABILITY LOG ENGINE ==="

TRACE_ID=$(date +%s)

LOG_FILE="accounts/OBSERVABILITY.LOG"

EVENT="TX_PROCESS"

echo "$TRACE_ID|$EVENT|START|NODE=LEADER" >> "$LOG_FILE"

sleep 1

echo "$TRACE_ID|$EVENT|PROCESS|STATUS=OK" >> "$LOG_FILE"

sleep 1

echo "$TRACE_ID|$EVENT|END|LATENCY=2s" >> "$LOG_FILE"

echo "[OK] TRACE GENERATED: $TRACE_ID"
