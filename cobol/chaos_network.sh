#!/usr/bin/env bash
set -euo pipefail

echo "=== CHAOS ENGINE: NETWORK SIMULATION ==="

RANDOM_DELAY=$((RANDOM % 3))

echo "[CHAOS] Injecting latency: ${RANDOM_DELAY}s"

sleep "$RANDOM_DELAY"

if [ $((RANDOM % 5)) -eq 0 ]; then
  echo "[CHAOS] NODE FAILURE SIMULATED"
  exit 1
fi

echo "[CHAOS] NETWORK OK"
