#!/bin/bash

echo "=== STRESS LOOP COBOL BANK ==="

set -e

./reset_env.sh
cobc -x -free -o procesa_transaccion multi_account_upgrade.cob

i=1
while [ $i -le 20 ]
do
  AMT=$(( (i * 13) % 250 ))
  printf "00001 %09d\n" "$AMT" > trans_input.txt

  echo ""
  echo ">>> ITER $i AMT=$AMT"
  ./procesa_transaccion

  ./patch_swap.sh

  i=$((i + 1))
done

echo ""
echo "=== FINAL STATE ==="
cat accounts/ACCOUNTS.DAT

echo "=== END STRESS ==="
