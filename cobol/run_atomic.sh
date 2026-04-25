#!/bin/bash

echo "=== ATOMIC ENGINE RUN ==="

set -e

./hard_reset_atomic.sh

cobc -x -free -o engine_v1_safe engine_v1_safe.cob

./engine_v1_safe

echo "[RESULT]"
ls -l accounts
cat accounts/JOURNAL.LOG
