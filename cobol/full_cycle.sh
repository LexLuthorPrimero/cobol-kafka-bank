#!/bin/bash

echo "=== FULL CYCLE COBOL BANK SYSTEM ==="

set -e

echo ""
echo "[0] RESET"
./reset_env.sh

echo ""
echo "[1] BUILD"
cobc -x -free -o procesa_transaccion multi_account_upgrade.cob

echo ""
echo "[2] BASE STATE"
cat accounts/ACCOUNTS.DAT

echo ""
echo "[3] TRANSACTIONS"
printf "00001 000000050\n" > trans_input.txt
./procesa_transaccion

printf "00001 000000120\n" > trans_input.txt
./procesa_transaccion

echo ""
echo "[4] SWAP"
./patch_swap.sh

echo ""
echo "[5] FINAL STATE"
cat accounts/ACCOUNTS.DAT

echo ""
echo "=== END FULL CYCLE ==="
