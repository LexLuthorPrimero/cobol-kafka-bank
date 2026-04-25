#!/bin/bash

echo "=== COMMIT ENGINE ==="

set -e

TEMP="accounts/TEMP.DAT"
FINAL="accounts/ACCOUNTS.DAT"

if [ ! -f "$TEMP" ]; then
  echo "[ERROR] TEMP NO EXISTE"
  exit 1
fi

if ./validator_v2.sh; then
  echo "[COMMIT] applying state"
  cp "$TEMP" "$FINAL"
  echo "[OK] COMMIT SUCCESS"
else
  echo "[ROLLBACK] discarding state"
  rm -f "$TEMP"
  echo "[OK] ROLLBACK DONE"
fi
