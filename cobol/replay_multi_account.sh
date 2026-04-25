#!/usr/bin/env bash
set -euo pipefail

JOURNAL="accounts/JOURNAL.LOG"
OUTPUT="accounts/ACCOUNTS.DAT"

declare -A SALDOS

echo "=== MULTI ACCOUNT REPLAY ==="

if [ ! -f "$JOURNAL" ]; then
  echo "[ERROR] JOURNAL NO EXISTE"
  exit 1
fi

while IFS= read -r line; do

  IFS='|' read -r VERSION STATUS ACC_ID AMOUNT <<< "$line"

  if [ "$VERSION" != "V1" ]; then
    continue
  fi

  if [ "$STATUS" != "OK" ]; then
    continue
  fi

  SALDOS["$ACC_ID"]=$(( ${SALDOS["$ACC_ID"]:-10000} - AMOUNT ))

done < "$JOURNAL"

> "$OUTPUT"

for id in "${!SALDOS[@]}"; do
  printf "%s%-20s%09d\n" "$id" "USER" "${SALDOS[$id]}" >> "$OUTPUT"
done

echo "[OK] MULTI ACCOUNT STATE REBUILT"
