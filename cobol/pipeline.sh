#!/bin/bash

echo "=== PIPELINE COMPLETO COBOL BANK ==="

set -e

./reset_env.sh

echo ""
echo "1) COMPILAR"
cobc -x -free -o procesa_transaccion procesa_transaccion.cob

echo ""
echo "2) TRANSACCION"
printf "00001 000000120\n" > trans_input.txt
./procesa_transaccion

echo ""
echo "3) SWAP"
./patch_swap.sh

echo ""
echo "4) VER ESTADO"
cat accounts/ACCOUNTS.DAT

echo ""
echo "=== FIN PIPELINE ==="
