#!/usr/bin/env bash
set -euo pipefail

FILE="accounts/partition_others.tmp"
STATE="accounts/state_other.tmp"

SALDO=10000

while IFS= read -r line; do

  IFS='|' read -r VERSION STATUS ACC_ID AMOUNT <<< "$line"

  if [ "$STATUS" = "OK" ]; then
    SALDO=$((SALDO - AMOUNT))
  fi

done < "$FILE"

echo "OTHER|$SALDO" > "$STATE"

echo "[OK] WORKER OTHER DONE"
