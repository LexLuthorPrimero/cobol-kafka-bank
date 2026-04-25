#!/usr/bin/env bash
set -euo pipefail

source ./idempotency_store.sh

EVENT_ID="$1"
ACC_ID="$2"
AMOUNT="$3"

echo "=== APPLY EVENT ==="
echo "EVENT: $EVENT_ID"

if is_seen "$EVENT_ID"; then
  echo "[DEDUP] EVENT ALREADY APPLIED: $EVENT_ID"
  exit 0
fi

mark_seen "$EVENT_ID"

echo "[APPLY] Processing transaction..."

FILE="accounts/ACCOUNTS.DAT"

SALDO=$(awk -v id="$ACC_ID" '$1==id {print $3}' "$FILE")

NEW=$((SALDO - AMOUNT))

echo "[STATE] OLD=$SALDO NEW=$NEW"

echo "[OK] EVENT APPLIED ONCE"
