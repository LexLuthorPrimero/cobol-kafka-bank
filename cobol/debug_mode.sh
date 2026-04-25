#!/bin/bash

echo "=== DEBUG MODE COBOL BANK (TRACE SIMPLE) ==="

set -e

./reset_env.sh

echo ""
echo "[BUILD]"
cobc -x -free -o procesa_transaccion procesa_transaccion.cob

echo ""
echo "[INPUT STATE]"
cat accounts/ACCOUNTS.DAT

echo ""
echo "[TRANSACTION TRACE]"
printf "00001 000000090\n" > trans_input.txt

echo "RUN -> procesa_transaccion"
./procesa_transaccion

echo ""
echo "CHECK TEMP (si existe)"
ls -l accounts/TEMP.DAT 2>/dev/null || echo "NO TEMP GENERADO"

echo ""
echo "APPLY SWAP"
./patch_swap.sh

echo ""
echo "[FINAL STATE]"
cat accounts/ACCOUNTS.DAT

echo "=== END DEBUG ==="
