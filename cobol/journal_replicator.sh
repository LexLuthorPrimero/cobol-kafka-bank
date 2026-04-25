#!/usr/bin/env bash
set -euo pipefail

PRIMARY="accounts/JOURNAL.LOG"
REPLICA1="accounts/JOURNAL_REPLICA_1.LOG"
REPLICA2="accounts/JOURNAL_REPLICA_2.LOG"

echo "=== JOURNAL REPLICATION ==="

if [ ! -f "$PRIMARY" ]; then
  echo "[ERROR] PRIMARY JOURNAL MISSING"
  exit 1
fi

cp "$PRIMARY" "$REPLICA1"
cp "$PRIMARY" "$REPLICA2"

echo "[OK] REPLICAS UPDATED"
