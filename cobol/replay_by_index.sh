#!/usr/bin/env bash
set -euo pipefail

JOURNAL="accounts/JOURNAL.LOG"
INDEX="accounts/JOURNAL.INDEX"

TARGET_ID="00001"
SALDO=10000
NAME="JUAN"

echo "=== INDEXED REPLAY ==="

if [ ! -f "$INDEX" ]; then
  echo "[ERROR] INDEX NO EXISTE"
  exit 1
fi

grep "^$TARGET_ID|" "$INDEX" | while IFS='|' read -r ID LINE; do

  LINE_CONTENT=$(sed -n "${LINE}p" "$JOURNAL")

  IFS='|' read -r VERSION STATUS ACC_ID AMOUNT <<< "$LINE_CONTENT"

  if [ "$STATUS" = "OK" ]; then
    SALDO=$((SALDO - AMOUNT))
  fi

done

echo "$TARGET_ID$NAME               $SALDO"
