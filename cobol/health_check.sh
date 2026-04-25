#!/usr/bin/env bash
set -euo pipefail

echo "=== HEALTH CHECK ==="

THROUGHPUT=$(wc -l < accounts/JOURNAL.LOG 2>/dev/null || echo 0)

if [ "$THROUGHPUT" -lt 10 ]; then
  echo "HEALTH: LOW LOAD / STABLE"
elif [ "$THROUGHPUT" -lt 100 ]; then
  echo "HEALTH: NORMAL OPERATION"
else
  echo "HEALTH: HIGH LOAD / DEGRADED MODE"
fi
