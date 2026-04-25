#!/usr/bin/env bash
set -euo pipefail

echo "=== OVERLOAD GENERATOR ==="

for i in $(seq 1 200); do
  echo "EVT_$i" >> accounts/queues/A.queue
  echo "EVT_$i" >> accounts/queues/B.queue
  echo "EVT_$i" >> accounts/queues/C.queue

  # inyección progresiva de presión
  if [ $i -gt 100 ]; then
    sleep 0.01
  fi
done

echo "[OK] OVERLOAD GENERATED"
