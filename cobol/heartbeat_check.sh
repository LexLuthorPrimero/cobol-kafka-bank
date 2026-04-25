#!/usr/bin/env bash
set -euo pipefail

echo "=== HEARTBEAT CHECK ==="

LEADER_FILE="accounts/LEADER.state"

if [ ! -f "$LEADER_FILE" ]; then
  echo "[FAIL] NO LEADER STATE"
  exit 1
fi

LEADER=$(cat "$LEADER_FILE")
FILE="accounts/JOURNAL_${LEADER}.LOG"

if [ ! -f "$FILE" ]; then
  echo "[FAIL] LEADER DOWN DETECTED: $LEADER"
  exit 1
fi

if [ ! -s "$FILE" ]; then
  echo "[WARN] LEADER EXISTS BUT EMPTY"
fi

echo "[OK] LEADER HEALTHY"
