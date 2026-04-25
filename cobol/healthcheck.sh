#!/bin/bash

echo "=== COBOL SYSTEM HEALTHCHECK ==="

# 1) binario
if [ -x ./procesa_transaccion ]; then
  echo "[OK] BINARIO OK"
else
  echo "[FAIL] BINARIO FALTANTE"
  exit 1
fi

# 2) datos
if [ -f accounts/ACCOUNTS.DAT ]; then
  echo "[OK] ACCOUNTS EXISTE"
else
  echo "[WARN] SIN ACCOUNTS.DAT"
fi

# 3) transacción
if [ -f trans_input.txt ]; then
  echo "[OK] TRANS INPUT OK"
else
  echo "[WARN] SIN TRANS INPUT"
fi

# 4) ejecución rápida controlada
echo ""
echo "=== QUICK RUN ==="
printf "00001 000000050\n" > trans_input.txt
./procesa_transaccion

echo ""
echo "=== END HEALTHCHECK ==="
