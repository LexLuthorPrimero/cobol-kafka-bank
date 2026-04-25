#!/usr/bin/env bash
set -euo pipefail

echo "=== STREAM PIPELINE ==="

./hard_reset.sh

cobc -x -free -o engine_v2_transactions engine_v2_transactions.cob
./engine_v2_transactions

./event_queue.sh
./event_worker.sh
./system_validator.sh

echo "=== DONE ==="
