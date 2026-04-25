#!/bin/bash

echo "=== ENGINE V3 FIXED ==="

set -e

./reset_env.sh

cobc -x -free -o engine_real_v3_fixed engine_real_v3_fixed.cob

./engine_real_v3_fixed

echo "=== DONE ==="
