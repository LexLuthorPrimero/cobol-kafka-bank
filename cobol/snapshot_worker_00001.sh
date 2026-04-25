#!/usr/bin/env bash
set -euo pipefail

PARTITION="accounts/partition_00001.tmp"
SNAPSHOT="accounts/snapshot_00001.dat"

BASE_SALDO=10000

echo "=== SNAPSHOT WORKER 00001 ==="

SALDO=$BASE_SALDO

while IFS= read -r line; do

  IFS='|' read -r VERSION STATUS ACC_ID AMOUNT <<< "$line"

  if [ "$STATUS" = "OK" ]; then
    SALDO=$((SALDO - AMOUNT))
  fi

done < "$PARTITION"

echo "00001|$SALDO" > "$SNAPSHOT"

echo "[OK] SNAPSHOT CREATED"
