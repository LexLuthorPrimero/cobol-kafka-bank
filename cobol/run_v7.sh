#!/bin/bash

echo "=== ENGINE V7 SAFE PARSE FIX ==="

set -e

./hard_reset.sh

cobc -x -free -o engine_v7 engine_v7.cob

./engine_v7

echo "[RESULT]"
cat accounts/TEMP.DAT
