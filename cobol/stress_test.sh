#!/bin/bash

echo "=== STRESS TEST COBOL BANK ==="

mkdir -p accounts

# estado inicial consistente
echo "00001JUAN               000010000" > accounts/ACCOUNTS.DAT

# múltiples transacciones encadenadas
for i in 1 2 3 4 5
do
  AMT=$((100 * i))
  printf "00001 %09d\n" "$AMT" > trans_input.txt

  echo "--- RUN $i (AMT=$AMT) ---"
  ./procesa_transaccion
  ./patch_swap.sh
done

echo ""
echo "=== FINAL STATE ==="
cat accounts/ACCOUNTS.DAT

echo "=== DONE ==="
