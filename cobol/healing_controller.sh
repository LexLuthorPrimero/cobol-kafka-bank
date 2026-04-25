#!/usr/bin/env bash
set -euo pipefail

echo "=== HEALING CONTROLLER ==="

if [ -f "accounts/ACCOUNTS.DAT" ]; then
  echo "[CHECK] STATE PRESENT"
else
  echo "[HEAL] RESTORE FROM SNAPSHOT"
  ./crash_recovery.sh
fi

if grep -q "FAIL" accounts/OBSERVABILITY.LOG 2>/dev/null; then
  echo "[HEAL] REPLAY JOURNAL"
  ./safe_replay_engine.sh
fi

echo "[OK] HEALING COMPLETE"
