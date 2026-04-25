#!/usr/bin/env bash
set -euo pipefail

echo "=== TX COORDINATOR (2PC SIMULATED) ==="

TX_ID=$(date +%s)

echo "[TX] START $TX_ID"

PREPARE_OK=true

for NODE in A B C; do
  echo "[PREPARE] NODE $NODE"

  # simulación de fallo
  if [ $((RANDOM % 10)) -lt 2 ]; then
    echo "[FAIL] NODE $NODE PREPARE FAILED"
    PREPARE_OK=false
  fi

done

if [ "$PREPARE_OK" = true ]; then
  echo "[COMMIT] ALL NODES"
  echo "$TX_ID|COMMIT" >> accounts/TX.LOG
else
  echo "[ROLLBACK] GLOBAL"
  echo "$TX_ID|ROLLBACK" >> accounts/TX.LOG
fi

echo "[TX END]"
