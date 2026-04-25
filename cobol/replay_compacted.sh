#!/usr/bin/env bash
set -euo pipefail

FILE="accounts/JOURNAL.COMPACTED"

SALDO=10000

echo "=== COMPACTED REPLAY ==="

while IFS='|' read -r VERSION STATUS ACC_ID AMOUNT; do

  if [ "$STATUS" = "OK" ]; then
    SALDO=$((SALDO - AMOUNT))
  fi

done < "$FILE"

echo "00001|$SALDO"
