#!/usr/bin/env bash
set -euo pipefail

NODES=("A" "B" "C")

echo "=== LEADER ELECTION ==="

# criterio determinístico simple: primer nodo vivo
LEADER=""

for n in "${NODES[@]}"; do
  FILE="accounts/JOURNAL_${n}.LOG"
  if [ -f "$FILE" ]; then
    LEADER="$n"
    break
  fi
done

if [ -z "$LEADER" ]; then
  echo "[FAIL] NO LEADER FOUND"
  exit 1
fi

echo "[LEADER ELECTED] NODE $LEADER"

echo "$LEADER" > accounts/LEADER.state
