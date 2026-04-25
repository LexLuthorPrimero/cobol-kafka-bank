#!/bin/bash

echo "=== REPLAY ENGINE ==="

set -e

JOURNAL="accounts/JOURNAL.LOG"
OUTPUT="accounts/ACCOUNTS.DAT"

if [ ! -f "$JOURNAL" ]; then
  echo "[ERROR] JOURNAL NO EXISTE"
  exit 1
fi

# estado base (puede evolucionar a múltiples cuentas luego)
SALDO=10000
ID="00001"
NAME="JUAN"

echo "[REPLAY START]"
echo "BASE SALDO: $SALDO"

while read -r STATUS ACC_ID AMOUNT; do

  if [ "$STATUS" != "OK" ]; then
    continue
  fi

  if [ "$ACC_ID" = "$ID" ]; then
    SALDO=$((SALDO - AMOUNT))
  fi

done < "$JOURNAL"

echo "[REPLAY END]"
echo "FINAL SALDO: $SALDO"

cat <<EOT > "$OUTPUT"
$ID$NAME               $SALDO
EOT

echo "[OK] ACCOUNTS RECONSTRUIDO DESDE JOURNAL"
