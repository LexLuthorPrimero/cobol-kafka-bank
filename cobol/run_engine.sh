#!/bin/bash

echo "=== REAL COBOL ENGINE ==="

set -e

./reset_env.sh

cobc -x -free -o engine_real engine_real.cob

echo "[RUN]"
./engine_real

echo "=== DONE ==="
