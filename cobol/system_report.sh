#!/bin/bash

echo "=== COBOL BANK SYSTEM REPORT ==="

echo ""
echo "== COMPILACION =="
if cobc -x -free -o procesa_transaccion procesa_transaccion.cob 2>/dev/null; then
  echo "OK"
else
  echo "FAIL"
  exit 1
fi

echo ""
echo "== ESTADO ACTUAL =="
cat accounts/ACCOUNTS.DAT 2>/dev/null || echo "SIN CUENTAS"

echo ""
echo "== EJECUCION CONTROLADA =="
printf "00001 000000075\n" > trans_input.txt
./procesa_transaccion

echo ""
echo "== CONSISTENCIA POST RUN =="
cat accounts/ACCOUNTS.DAT 2>/dev/null || echo "SIN CUENTAS"

echo ""
echo "=== END REPORT ==="
