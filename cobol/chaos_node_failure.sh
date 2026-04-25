#!/usr/bin/env bash
set -euo pipefail

echo "=== CHAOS ENGINE: NODE FAILURE ==="

for n in A B C; do
  if [ $((RANDOM % 4)) -eq 0 ]; then
    echo "[CHAOS] DISABLING NODE $n"
    rm -f "accounts/JOURNAL_${n}.LOG"
  fi
done

echo "[CHAOS] NODE STATE MODIFIED"
