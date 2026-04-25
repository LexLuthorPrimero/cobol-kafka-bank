#!/usr/bin/env bash
set -euo pipefail

JOURNAL="accounts/JOURNAL.LOG"
INDEX="accounts/JOURNAL.INDEX"

if [ ! -f "$JOURNAL" ]; then
  echo "[ERROR] JOURNAL NO EXISTE"
  exit 1
fi

> "$INDEX"

LINE_NUM=0

while IFS= read -r line; do

  LINE_NUM=$((LINE_NUM + 1))

  IFS='|' read -r VERSION STATUS ACC_ID AMOUNT <<< "$line"

  if [ "$VERSION" != "V1" ]; then
    continue
  fi

  echo "$ACC_ID|$LINE_NUM" >> "$INDEX"

done < "$JOURNAL"

echo "[OK] INDEX GENERATED"
