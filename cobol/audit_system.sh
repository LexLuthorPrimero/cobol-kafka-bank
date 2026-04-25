#!/usr/bin/env bash
set -euo pipefail

echo "=== AUDIT SYSTEM ==="

LOG="accounts/OBSERVABILITY.LOG"

echo "[AUDIT] LAST EVENTS:"
tail -n 5 "$LOG" || true

echo "[OK] AUDIT COMPLETE"
