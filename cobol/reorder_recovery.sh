#!/usr/bin/env bash
set -euo pipefail

echo "=== REORDER RECOVERY ENGINE ==="

INPUT="accounts/NETWORK_BUFFER.LOG"
OUTPUT="accounts/REORDERED.LOG"

sort "$INPUT" > "$OUTPUT"

echo "[OK] ORDER RESTORED (BEST EFFORT)"
