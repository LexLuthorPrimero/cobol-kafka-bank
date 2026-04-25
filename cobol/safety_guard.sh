#!/bin/bash

echo "=== SAFETY GUARD COBOL BANK ==="

# evita ejecución si falta base crítica
if [ ! -f multi_account_upgrade.cob ]; then
  echo "ERROR: COBOL SOURCE MISSING"
  exit 1
fi

if [ ! -d accounts ]; then
  echo "ERROR: ACCOUNTS DIR MISSING"
  exit 1
fi

echo "OK ENV SAFE"

# ejecución controlada
cobc -x -free -o procesa_transaccion multi_account_upgrade.cob

printf "00001 000000060\n" > trans_input.txt
./procesa_transaccion

echo ""
echo "STATE:"
cat accounts/ACCOUNTS.DAT 2>/dev/null || echo "NO DATA"

echo "=== END SAFETY ==="
