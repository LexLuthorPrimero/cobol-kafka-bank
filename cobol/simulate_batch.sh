#!/bin/bash

echo "=== SIMULACION BATCH MULTI-TRANSACCION ==="

set -e

./reset_env.sh
cobc -x -free -o procesa_transaccion procesa_transaccion.cob

# serie de transacciones encadenadas
TRANS=("000000050" "000000200" "000000150" "000000300")

for i in "${!TRANS[@]}"
do
  echo "00001 ${TRANS[$i]}" > trans_input.txt

  echo ""
  echo ">>> CICLO $((i+1)) AMT=${TRANS[$i]}"
  ./procesa_transaccion
  ./patch_swap.sh
done

echo ""
echo "=== RESULTADO FINAL ==="
cat accounts/ACCOUNTS.DAT

echo "=== FIN SIMULACION ==="
