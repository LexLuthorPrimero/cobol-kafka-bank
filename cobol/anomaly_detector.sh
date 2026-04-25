#!/usr/bin/env bash
set -euo pipefail

echo "=== ANOMALY DETECTOR ==="

LOG="accounts/OBSERVABILITY.LOG"

LATENCY_COUNT=$(grep "LATENCY" "$LOG" | wc -l || true)
FAIL_COUNT=$(grep "FAIL" "$LOG" | wc -l || true)

echo "LATENCY=$LATENCY_COUNT"
echo "FAILURES=$FAIL_COUNT"

if [ "$FAIL_COUNT" -gt 0 ]; then
  echo "[ALERT] FAILURE DETECTED"
  exit 2
fi

if [ "$LATENCY_COUNT" -gt 5 ]; then
  echo "[WARN] HIGH LATENCY DETECTED"
fi

echo "[OK] SYSTEM HEALTHY"
