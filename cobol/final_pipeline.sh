#!/bin/bash

echo "=== FINAL PIPELINE COBOL BANK (END-TO-END) ==="

set -e

./reset_env.sh

echo ""
echo "[1] COMPILACION"
cobc -x -free -o procesa_transaccion procesa_transaccion.cob

echo ""
echo "[2] ESTADO INICIAL"
cat accounts/ACCOUNTS.DAT

echo ""
echo "[3] BATCH TRANSACCIONES"
AMOUNTS="000000050 000000120 000000080"

for amt in $AMOUNTS
do
  printf "00001 %s\n" "$amt" > trans_input.txt
  ./procesa_transaccion
  ./patch_swap.sh
done

echo ""
echo "[4] ESTADO FINAL"
cat accounts/ACCOUNTS.DAT

echo ""
echo "=== DONE ==="
