#!/bin/bash

echo "=== ENGINE REAL V3 ==="

set -e

./reset_env.sh

echo "[BUILD]"
cobc -x -free -o engine_real_v3 engine_real_v3.cob

echo "[RUN]"
./engine_real_v3

echo "[DONE]"
