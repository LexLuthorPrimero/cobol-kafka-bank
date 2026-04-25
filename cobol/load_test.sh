#!/bin/bash

echo "=== LOAD TEST COBOL BANK ==="

set -e

./reset_env.sh
cobc -x -free -o procesa_transaccion procesa_transaccion.cob

# carga masiva de transacciones simuladas
for i in $(seq 1 10)
do
  AMT=$((i * 37))
  printf "00001 %09d\n" "$AMT" > trans_input.txt

  echo ""
  echo ">>> RUN $i AMT=$AMT"
  ./procesa_transaccion
  ./patch_swap.sh
done

echo ""
echo "=== FINAL STATE ==="
cat accounts/ACCOUNTS.DAT

echo "=== END LOAD TEST ==="
