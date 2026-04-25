#!/bin/bash

echo "=== STAGE 2 TEST JOURNAL SYSTEM ==="

set -e

./reset_env.sh

echo ""
echo "[BUILD]"
cobc -x -free -o procesa_transaccion stage2_journal_upgrade.cob

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
echo "[RESULT ACCOUNTS]"
cat accounts/ACCOUNTS.DAT

echo ""
echo "[JOURNAL]"
cat accounts/JOURNAL.LOG 2>/dev/null || echo "NO JOURNAL"

echo "=== END STAGE 2 ==="
