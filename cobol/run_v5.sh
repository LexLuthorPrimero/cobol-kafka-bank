#!/bin/bash

echo "=== ENGINE V5 BANK CORE ==="

set -e

./hard_reset.sh

cobc -x -free -o engine_v5 engine_v5.cob

./engine_v5

echo "[RESULT]"
cat accounts/ACCOUNTS.DAT
