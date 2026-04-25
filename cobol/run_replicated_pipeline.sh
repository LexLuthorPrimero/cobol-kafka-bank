#!/usr/bin/env bash
set -euo pipefail

echo "=== REPLICATED SYSTEM PIPELINE ==="

./hard_reset.sh

cobc -x -free -o engine_v2_transactions engine_v2_transactions.cob
./engine_v2_transactions

./journal_replicator.sh
./journal_selector.sh

./partition_events.sh
./snapshot_worker_00001.sh

echo "[OK] DISTRIBUTED SAFE STATE ACHIEVED"
