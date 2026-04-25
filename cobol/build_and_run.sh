#!/bin/bash

echo "=== COBOL AUTO PIPELINE ==="

set -e

echo ""
echo "[1] RESET"
./reset_env.sh

echo ""
echo "[2] WRITE TRANS INPUT"
cat <<EOT > trans_input.txt
00001 000000070
00001 000000030
EOT

echo ""
echo "[3] BUILD COBOL"
cobc -x -free -o stage5_engine stage5_indexed_engine.cob

echo ""
echo "[4] INPUT ACCOUNTS"
cat accounts/ACCOUNTS.DAT

echo ""
echo "[5] RUN ENGINE"
./stage5_engine

echo ""
echo "[6] RESULT ACCOUNTS"
cat accounts/ACCOUNTS.DAT

echo ""
echo "[7] JOURNAL"
cat accounts/JOURNAL.LOG 2>/dev/null || echo "NO JOURNAL"

echo ""
echo "=== DONE ==="

