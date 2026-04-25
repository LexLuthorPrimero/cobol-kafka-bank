#!/bin/bash

echo "=== STATE VALIDATOR V2 ==="

set -e

ACCOUNTS_FILE="accounts/ACCOUNTS.DAT"
INPUT_FILE="trans_input.txt"

echo "[READ INPUT]"
cat "$INPUT_FILE"

echo ""
echo "[READ FINAL ACCOUNTS]"
cat "$ACCOUNTS_FILE"

echo ""

EXPECTED_START=10000

TOTAL_TX=$(awk '{sum += $2} END {print sum}' "$INPUT_FILE")
ACTUAL_BALANCE=$(awk '{print $3}' "$ACCOUNTS_FILE")

EXPECTED_BALANCE=$((EXPECTED_START - TOTAL_TX))

echo "[CALCULATION]"
echo "START=$EXPECTED_START"
echo "TOTAL_TX=$TOTAL_TX"
echo "EXPECTED=$EXPECTED_BALANCE"
echo "ACTUAL=$ACTUAL_BALANCE"

echo ""

if [ "$EXPECTED_BALANCE" -eq "$ACTUAL_BALANCE" ]; then
    echo "[OK] INVARIANT VALID"
    exit 0
else
    echo "[FAIL] INVARIANT BROKEN"
    exit 1
fi
