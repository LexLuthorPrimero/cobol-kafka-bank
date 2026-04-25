#!/usr/bin/env bash
set -euo pipefail

LOG="accounts/CONSENSUS.LOG"

echo "=== REPLICATE CONSENSUS LOG ==="

if [ ! -f "$LOG" ]; then
  echo "[ERROR] NO CONSENSUS LOG"
  exit 1
fi

for n in A B C; do
  cp "$LOG" "accounts/CONSENSUS_${n}.LOG"
done

echo "[OK] ALL NODES SYNCHRONIZED"
