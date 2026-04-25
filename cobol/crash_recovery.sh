#!/usr/bin/env bash
set -euo pipefail

echo "=== CRASH RECOVERY ENGINE ==="

SNAPSHOT="accounts/snapshots/snapshot.dat"
JOURNAL="accounts/JOURNAL.LOG"
OUTPUT="accounts/ACCOUNTS.DAT"

if [ ! -f "$SNAPSHOT" ]; then
  echo "[ERROR] NO SNAPSHOT FOUND"
  exit 1
fi

echo "[RESTORE] SNAPSHOT BASE"
cp "$SNAPSHOT" "$OUTPUT"

echo "[REPLAY] JOURNAL DELTA"

while read -r line; do
  STATUS=$(echo "$line" | awk '{print $2}')
  ID=$(echo "$line" | awk '{print $3}')
  AMT=$(echo "$line" | awk '{print $4}')

  if [ "$STATUS" != "OK" ]; then
    continue
  fi

  # simulación simple de replay
  echo "[APPLY EVENT] $ID -$AMT"

done < "$JOURNAL"

echo "[OK] RECOVERY COMPLETE"
