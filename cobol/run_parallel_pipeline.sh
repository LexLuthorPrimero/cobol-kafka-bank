#!/usr/bin/env bash
set -euo pipefail

echo "=== PARALLEL PIPELINE ==="

./hard_reset.sh

cobc -x -free -o engine_v2_transactions engine_v2_transactions.cob
./engine_v2_transactions

./partition_events.sh

./worker_00001.sh &
./worker_generic.sh &
wait

echo "[OK] ALL WORKERS FINISHED"
