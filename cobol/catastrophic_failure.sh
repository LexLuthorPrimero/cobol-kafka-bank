#!/usr/bin/env bash
set -euo pipefail

echo "=== CATASTROPHIC FAILURE SIMULATION ==="

echo "[STEP 1] Removing node state..."

rm -f accounts/ACCOUNTS.DAT || true
rm -f accounts/JOURNAL.LOG || true

echo "[STEP 2] Corrupting queues..."

echo "CORRUPTED_DATA" > accounts/queues/A.queue
echo "" > accounts/queues/B.queue

echo "[STEP 3] Simulating split-brain"

echo "[OK] SYSTEM IN PARTIAL FAILURE STATE"
