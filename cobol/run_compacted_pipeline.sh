#!/usr/bin/env bash
set -euo pipefail

echo "=== COMPACTED PIPELINE ==="

./hard_reset.sh

cobc -x -free -o engine_v2_transactions engine_v2_transactions.cob
./engine_v2_transactions

./journal_compactor.sh
./snapshot_worker_00001.sh
./replay_compacted.sh

echo "[OK] COMPACT SYSTEM RUNNING"
