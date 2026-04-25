#!/usr/bin/env bash
set -euo pipefail

echo "=== FAILOVER ENGINE ==="

NODES=("A" "B" "C")
CURRENT=$(cat accounts/LEADER.state 2>/dev/null || echo "")

echo "CURRENT LEADER: $CURRENT"

NEW=""

for n in "${NODES[@]}"; do
  if [ "$n" != "$CURRENT" ] && [ -f "accounts/JOURNAL_${n}.LOG" ]; then
    NEW="$n"
    break
  fi
done

if [ -z "$NEW" ]; then
  echo "[FAIL] NO REPLACEMENT FOUND"
  exit 1
fi

echo "[FAILOVER] NEW LEADER = $NEW"

echo "$NEW" > accounts/LEADER.state

echo "[OK] LEADER SWITCH COMPLETE"
