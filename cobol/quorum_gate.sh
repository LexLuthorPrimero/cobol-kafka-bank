#!/usr/bin/env bash
set -euo pipefail

echo "=== QUORUM GATE ==="

NODES=("A" "B" "C")
ACTIVE=0

for n in "${NODES[@]}"; do
  FILE="accounts/JOURNAL_${n}.LOG"
  if [ -f "$FILE" ]; then
    ACTIVE=$((ACTIVE + 1))
  fi
done

echo "ACTIVE NODES: $ACTIVE"

if [ "$ACTIVE" -lt 2 ]; then
  echo "[FATAL] SPLIT BRAIN DETECTED - NO QUORUM"
  exit 1
fi

echo "[OK] QUORUM ACHIEVED - SYSTEM ACTIVE"
