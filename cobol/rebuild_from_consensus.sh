#!/usr/bin/env bash
set -euo pipefail

echo "=== REBUILD FROM CONSENSUS LOG ==="

LOG="accounts/CONSENSUS.LOG"

SALDO=10000

while IFS='|' read -r IDX VERSION STATUS ID AMOUNT; do

  if [ "$STATUS" = "OK" ]; then
    SALDO=$((SALDO - AMOUNT))
  fi

done < "$LOG"

echo "FINAL STATE: $SALDO"

cat <<EOT > accounts/ACCOUNTS.DAT
00001JUAN               $SALDO
EOT

echo "[OK] STATE REBUILT FROM GLOBAL ORDER"
