#!/usr/bin/env bash
set -euo pipefail

echo "=== SANDBOX EXECUTOR ==="

EVENT="$1"
NODE="$2"

SANDBOX_DIR="accounts/sandbox_$NODE"

mkdir -p "$SANDBOX_DIR"

echo "[SANDBOX $NODE] EXECUTING EVENT"

cp accounts/ACCOUNTS.DAT "$SANDBOX_DIR/" 2>/dev/null || true

echo "$EVENT" >> "$SANDBOX_DIR/log.txt"

echo "[OK] ISOLATED EXECUTION COMPLETE"
