#!/usr/bin/env bash
set -euo pipefail

echo "=== SYSTEM DAMAGE DETECTOR ==="

if [ ! -f "accounts/ACCOUNTS.DAT" ]; then
  echo "[CRITICAL] CORE STATE MISSING"
fi

if [ ! -f "accounts/JOURNAL.LOG" ]; then
  echo "[CRITICAL] JOURNAL MISSING"
fi

if grep -q "CORRUPTED" accounts/queues/A.queue 2>/dev/null; then
  echo "[CRITICAL] QUEUE CORRUPTION DETECTED"
fi

echo "[OK] DAMAGE ASSESSED"
