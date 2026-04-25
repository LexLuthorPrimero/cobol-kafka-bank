#!/bin/bash

echo "=== FINALIZE COBOL BANK SYSTEM ==="

set -e

./reset_env.sh

echo ""
echo "[1] BUILD FINAL VERSION"
cobc -x -free -o procesa_transaccion multi_account_upgrade.cob

echo ""
echo "[2] INIT STATE"
cat accounts/ACCOUNTS.DAT

echo ""
echo "[3] EXECUTION SEQUENCE"
printf "00001 000000030\n" > trans_input.txt
./procesa_transaccion

./patch_swap.sh

printf "00001 000000080\n" > trans_input.txt
./procesa_transaccion

./patch_swap.sh

echo ""
echo "[4] FINAL STATE"
cat accounts/ACCOUNTS.DAT

echo ""
echo "=== SYSTEM READY (BATCH COBOL CORE COMPLETE) ==="
