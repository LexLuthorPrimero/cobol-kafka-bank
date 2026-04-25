#!/usr/bin/env bash
set -euo pipefail

echo "=== RESILIENT PIPELINE ==="

./hard_reset.sh

cobc -x -free -o engine_v2_transactions engine_v2_transactions.cob
./engine_v2_transactions

./partition_events.sh

./snapshot_worker_00001.sh
./worker_generic.sh

./replay_from_snapshot.sh

echo "[OK] SYSTEM RECOVERABLE"
