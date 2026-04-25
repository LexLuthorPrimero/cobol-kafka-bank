#!/bin/bash

echo "=== COBOL BANK SYSTEM TEST ==="

set -e

echo ""
echo "[RESET]"
./reset_env.sh

echo ""
echo "[INPUT TRANS]"
cat <<EOT > trans_input.txt
00001 000000070
00001 000000030
EOT

echo ""
echo "[BUILD]"
cobc -x -free -o bank_engine stage5_indexed_engine.cob

echo ""
echo "[INPUT ACCOUNTS]"
cat accounts/ACCOUNTS.DAT

echo ""
echo "[RUN]"
./bank_engine

echo ""
echo "[RESULT ACCOUNTS]"
cat accounts/ACCOUNTS.DAT

echo ""
echo "[JOURNAL]"
cat accounts/JOURNAL.LOG 2>/dev/null || echo "NO JOURNAL FOUND"

echo ""
echo "=== END TEST ==="

