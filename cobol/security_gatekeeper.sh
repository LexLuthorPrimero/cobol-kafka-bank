#!/usr/bin/env bash
set -euo pipefail

echo "=== SECURITY GATEKEEPER ==="

INPUT="$1"

if [[ "$INPUT" == *"rm -rf"* ]]; then
  echo "[BLOCKED] DANGEROUS COMMAND DETECTED"
  exit 1
fi

if [[ "$INPUT" == *"CORRUPT"* ]]; then
  echo "[BLOCKED] MALICIOUS PATTERN"
  exit 1
fi

echo "[OK] INPUT SAFE"
echo "$INPUT"
