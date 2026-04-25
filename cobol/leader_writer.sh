#!/usr/bin/env bash
set -euo pipefail

EVENT="V1|OK|00001|70"

LEADER=$(cat accounts/LEADER.state)

echo "=== LEADER WRITER ==="
echo "CURRENT LEADER: $LEADER"

FILE="accounts/JOURNAL_${LEADER}.LOG"

if [ ! -f "$FILE" ]; then
  echo "[ERROR] LEADER JOURNAL MISSING"
  exit 1
fi

echo "$EVENT" >> "$FILE"

echo "[OK] WRITTEN BY LEADER $LEADER"
