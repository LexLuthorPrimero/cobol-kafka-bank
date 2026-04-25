#!/usr/bin/env bash
set -euo pipefail

echo "=== DECISION ENGINE ==="

THROUGHPUT=$(wc -l < accounts/JOURNAL.LOG 2>/dev/null || echo 0)

if [ "$THROUGHPUT" -lt 10 ]; then
  echo "[DECISION] NORMAL MODE"
  ACTION="none"

elif [ "$THROUGHPUT" -lt 100 ]; then
  echo "[DECISION] THROTTLE MODE"
  ACTION="throttle"

else
  echo "[DECISION] STRESS DETECTED"
  ACTION="heal"
fi

echo "$ACTION" > /tmp/system_action.flag
