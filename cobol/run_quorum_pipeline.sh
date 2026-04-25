#!/usr/bin/env bash
set -euo pipefail

echo "=== QUORUM SYSTEM START ==="

./hard_reset.sh

cobc -x -free -o engine_v2_transactions engine_v2_transactions.cob
./engine_v2_transactions

./journal_replicator.sh

./quorum_writer.sh
./quorum_validator.sh

./partition_events.sh
./snapshot_worker_00001.sh

echo "[OK] DISTRIBUTED CONSISTENCY ACHIEVED"
