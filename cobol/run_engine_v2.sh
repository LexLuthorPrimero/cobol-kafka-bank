#!/bin/bash

echo "=== ENGINE V2 (IDEMPOTENT) ==="

set -e

./reset_env.sh

cobc -x -free -o engine_real_v2 engine_real_v2.cob

echo "[RUN]"
./engine_real_v2

echo "=== DONE ==="
