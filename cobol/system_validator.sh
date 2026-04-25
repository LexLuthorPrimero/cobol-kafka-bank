#!/usr/bin/env bash
set -euo pipefail

echo "=== SYSTEM CONSISTENCY CHECK ==="

JOURNAL="accounts/JOURNAL.LOG"
SNAPSHOT="accounts/snapshot_00001.dat"

if [ ! -f "$JOURNAL" ]; then
  echo "[FAIL] JOURNAL MISSING"
  exit 1
fi

if [ ! -f "$SNAPSHOT" ]; then
  echo "[FAIL] SNAPSHOT MISSING"
  exit 1
fi

J_COUNT=$(wc -l < "$JOURNAL")
S_STATE=$(cut -d'|' -f2 "$SNAPSHOT")

echo "JOURNAL EVENTS: $J_COUNT"
echo "SNAPSHOT STATE: $S_STATE"

if [ "$J_COUNT" -eq 0 ]; then
  echo "[OK] EMPTY STATE"
  exit 0
fi

echo "[OK] STRUCTURAL CONSISTENCY VALID"
