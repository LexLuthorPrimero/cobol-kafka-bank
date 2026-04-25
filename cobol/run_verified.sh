#!/bin/bash

echo "=== ENGINE + VERIFY PIPELINE ==="

set -e

./hard_reset.sh

cobc -x -free -o engine_v2_transactions engine_v2_transactions.cob
./engine_v2_transactions

./verify_state.sh

echo "=== DONE ==="
