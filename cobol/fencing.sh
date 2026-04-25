#!/usr/bin/env bash
set -euo pipefail

echo "=== FENCING MINORITY NODES ==="

for n in A B C; do
  FILE="accounts/JOURNAL_${n}.LOG"

  if [ ! -f "$FILE" ]; then
    echo "[FENCE] NODE $n ISOLATED"
    touch "accounts/FENCED_${n}"
  fi
done

echo "[OK] FENCING COMPLETE"
