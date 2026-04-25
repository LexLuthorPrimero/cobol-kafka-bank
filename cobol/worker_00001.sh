#!/usr/bin/env bash
set -euo pipefail

FILE="accounts/partition_00001.tmp"
STATE="accounts/state_00001.tmp"

SALDO=10000

while IFS= read -r line; do

  IFS='|' read -r VERSION STATUS ACC_ID AMOUNT <<< "$line"

  if [ "$STATUS" = "OK" ]; then
    SALDO=$((SALDO - AMOUNT))
  fi

done < "$FILE"

echo "00001|$SALDO" > "$STATE"

echo "[OK] WORKER 00001 DONE"
