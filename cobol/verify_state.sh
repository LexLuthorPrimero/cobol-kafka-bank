#!/bin/bash

echo "=== STATE VALIDATOR ==="

set -e

echo "[READ FINAL ACCOUNTS]"
cat accounts/ACCOUNTS.DAT

echo ""
echo "[READ INPUT]"
cat trans_input.txt

echo ""
echo "[CHECK: basic consistency]"

# regla simple: archivo debe existir y no estar vacío
if [ ! -s accounts/ACCOUNTS.DAT ]; then
  echo "ERROR: ACCOUNTS EMPTY"
  exit 1
fi

if [ ! -s trans_input.txt ]; then
  echo "ERROR: INPUT EMPTY"
  exit 1
fi

echo "[OK] BASIC STATE VALID"

