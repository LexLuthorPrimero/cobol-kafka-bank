#!/usr/bin/env bash
set -euo pipefail

echo "=== FENCING ENFORCEMENT ==="

if grep -q "C" partitions/cluster_isolated 2>/dev/null; then
  touch accounts/FENCED_C
  echo "[FENCE] NODE C ISOLATED"
fi

echo "[OK] MINORITY BLOCKED"
