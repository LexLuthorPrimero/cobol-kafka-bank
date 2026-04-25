#!/usr/bin/env bash
set -euo pipefail

LEADER=$(cat accounts/LEADER.state)

SRC="accounts/JOURNAL_${LEADER}.LOG"

echo "=== REPLICATION FROM LEADER $LEADER ==="

for n in A B C; do
  cp "$SRC" "accounts/JOURNAL_${n}.LOG"
done

echo "[OK] REPLICATION COMPLETE"
