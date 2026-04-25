#!/bin/bash

echo "=== ENGINE CLEAN RUN ==="

set -e

./hard_reset.sh

echo "[BUILD]"
cobc -x -free -o engine_v4 engine_v4.cob

echo "[RUN]"
./engine_v4

echo "[DONE]"
