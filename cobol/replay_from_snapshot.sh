#!/usr/bin/env bash
set -euo pipefail

SNAPSHOT="accounts/snapshot_00001.dat"
PARTITION="accounts/partition_00001.tmp"

echo "=== REPLAY FROM SNAPSHOT ==="

if [ ! -f "$SNAPSHOT" ]; then
  echo "[ERROR] SNAPSHOT MISSING"
  exit 1
fi

SALDO=$(cut -d'|' -f2 "$SNAPSHOT")

while IFS= read -r line; do

  IFS='|' read -r VERSION STATUS ACC_ID AMOUNT <<< "$line"

  if [ "$STATUS" = "OK" ]; then
    SALDO=$((SALDO - AMOUNT))
  fi

done < "$PARTITION"

echo "00001|$SALDO"
