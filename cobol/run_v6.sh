#!/bin/bash

echo "=== ENGINE V6 FIX ARCHITECTURE ==="

set -e

./hard_reset.sh

cobc -x -free -o engine_v6 engine_v6.cob

./engine_v6

echo "[RESULT]"
cat accounts/TEMP.DAT
