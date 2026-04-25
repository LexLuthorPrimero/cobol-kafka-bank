#!/bin/bash

echo "=== ENGINE V8 FIXED FILE MODEL ==="

set -e

./hard_reset.sh

cobc -x -free -o engine_v8 engine_v8.cob

./engine_v8

echo "[RESULT]"
cat accounts/TEMP.DAT
