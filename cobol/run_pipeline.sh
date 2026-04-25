#!/bin/bash

set -euo pipefail

echo "=== PIPELINE START ==="

./reset_atomic.sh

echo "[BUILD]"
cobc -x -free -o engine_core engine_v2_transactions.cob

echo "[RUN]"
./engine_core

echo "[VERIFY FILES]"
ls -l accounts
echo "---- ACCOUNTS ----"
cat accounts/ACCOUNTS.DAT || true
echo "---- JOURNAL ----"
cat accounts/JOURNAL.LOG || echo "NO JOURNAL"

echo "=== PIPELINE END ==="
