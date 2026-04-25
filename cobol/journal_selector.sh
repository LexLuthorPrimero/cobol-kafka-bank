#!/usr/bin/env bash
set -euo pipefail

A="accounts/JOURNAL.LOG"
B="accounts/JOURNAL_REPLICA_1.LOG"
C="accounts/JOURNAL_REPLICA_2.LOG"

echo "=== JOURNAL SELECTOR ==="

choose_valid() {
  if [ -s "$A" ]; then echo "$A"; return; fi
  if [ -s "$B" ]; then echo "$B"; return; fi
  if [ -s "$C" ]; then echo "$C"; return; fi
  echo ""
}

SELECTED=$(choose_valid)

if [ -z "$SELECTED" ]; then
  echo "[FAIL] NO VALID JOURNAL"
  exit 1
fi

echo "[OK] USING $SELECTED"

export ACTIVE_JOURNAL="$SELECTED"
