#!/usr/bin/env bash
set -euo pipefail

echo "=== RESILIENCE REPORT ==="

LOG="accounts/OBSERVABILITY.LOG"

TOTAL=$(wc -l < "$LOG" 2>/dev/null || echo 0)
FAILS=$(grep -c "FAIL" "$LOG" || true)
OKS=$(grep -c "OK" "$LOG" || true)

echo "TOTAL_EVENTS=$TOTAL"
echo "SUCCESS=$OKS"
echo "FAILURES=$FAILS"

if [ "$TOTAL" -gt 0 ]; then
  RATIO=$(echo "$OKS / $TOTAL" | bc -l)
  echo "SUCCESS_RATIO=$RATIO"
fi

echo "[OK] RESILIENCE EVALUATED"
