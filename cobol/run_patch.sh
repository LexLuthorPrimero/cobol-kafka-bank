#!/bin/bash

echo "=== COBOL FIX PIPELINE ==="

set -e

echo "[RESET]"
./reset_env.sh

echo "[BUILD]"
cobc -x -free -o patch_engine patch_logic.cob

echo "[RUN]"
./patch_engine

echo "=== DONE ==="

