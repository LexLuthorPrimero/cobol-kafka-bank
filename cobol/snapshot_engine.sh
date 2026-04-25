#!/usr/bin/env bash
set -euo pipefail

JOURNAL="accounts/JOURNAL.LOG"
SNAPSHOT="accounts/SNAPSHOT.STATE"

if [ ! -f "$JOURNAL" ]; then
  echo "[ERROR] JOURNAL NO EXISTE"
  exit 1
fi

SALDO=10000
ID="00001"

while IFS= read -r line; do

  IFS='|' read -r VERSION STATUS ACC_ID AMOUNT <<< "$line"

  if [ "$VERSION" != "V1" ]; then
    continue
  fi

  if [ "$STATUS" != "OK" ]; then
    continue
  fi

  if [ "$ACC_ID" = "$ID" ]; then
    SALDO=$((SALDO - AMOUNT))
  fi

done < "$JOURNAL"

echo "$ID|$SALDO" > "$SNAPSHOT"

echo "[OK] SNAPSHOT GENERATED"
