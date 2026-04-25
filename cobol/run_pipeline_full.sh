#!/usr/bin/env bash
set -euo pipefail

echo "=== FULL EVENT PIPELINE ==="

echo "1. RESET STATE"
./hard_reset.sh

echo "2. RUN COBOL ENGINE"
cobc -x -free -o engine_v2_transactions engine_v2_transactions.cob
./engine_v2_transactions

echo "3. BUILD INDEX"
./journal_indexer.sh

echo "4. REPLAY STATE"
./replay_by_index.sh > /dev/null

echo "5. VALIDATE SYSTEM"
./system_validator.sh

echo "=== PIPELINE COMPLETE ==="
