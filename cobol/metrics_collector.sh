#!/usr/bin/env bash
set -euo pipefail

echo "=== METRICS COLLECTOR ==="

TS=$(date +%s)

THROUGHPUT=$(wc -l < accounts/JOURNAL.LOG 2>/dev/null || echo 0)
ACCOUNTS=$(wc -l < accounts/ACCOUNTS.DAT 2>/dev/null || echo 0)

echo "timestamp:$TS"
echo "throughput:$THROUGHPUT"
echo "accounts:$ACCOUNTS"

echo "[OK] METRICS COLLECTED"
