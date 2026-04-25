#!/bin/bash

echo "=== BUILD & RUN FIXED STAGE 2 ==="

set -e

./reset_env.sh

echo "[BUILD]"
cobc -x -free -o procesa_transaccion stage2_fixed.cob

echo ""
echo "[INPUT]"
cat accounts/ACCOUNTS.DAT

echo ""
echo "[TRANS]"
printf "00001 000000070\n" > trans_input.txt

echo ""
echo "[RUN]"
./procesa_transaccion

echo ""
echo "[STAGING RESULT]"
cat accounts/TEMP.DAT

echo ""
echo "[COMMIT LAYER]"
cp accounts/TEMP.DAT accounts/ACCOUNTS.DAT

echo ""
echo "[FINAL STATE]"
cat accounts/ACCOUNTS.DAT

echo ""
echo "[JOURNAL]"
cat accounts/JOURNAL.LOG

echo "=== DONE ==="
