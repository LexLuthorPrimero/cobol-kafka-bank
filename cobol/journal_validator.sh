#!/bin/bash

echo "=== JOURNAL VALIDATOR ==="

set -e

FILE="accounts/JOURNAL.LOG"

if [ ! -f "$FILE" ]; then
  echo "[ERROR] JOURNAL NO EXISTE"
  exit 1
fi

echo "[CHECK FORMAT]"

while IFS= read -r line; do

  IFS='|' read -r VERSION STATUS ID AMOUNT <<< "$line"

  if [ "$VERSION" != "V1" ]; then
    echo "[FAIL] VERSION INVALID: $line"
    exit 1
  fi

  if [ "$STATUS" != "OK" ] && [ "$STATUS" != "FAIL" ]; then
    echo "[FAIL] STATUS INVALID: $line"
    exit 1
  fi

  if ! [[ "$ID" =~ ^[0-9]+$ ]]; then
    echo "[FAIL] ID INVALID: $line"
    exit 1
  fi

  if ! [[ "$AMOUNT" =~ ^[0-9]+$ ]]; then
    echo "[FAIL] AMOUNT INVALID: $line"
    exit 1
  fi

done < "$FILE"

echo "[OK] JOURNAL VALID"
