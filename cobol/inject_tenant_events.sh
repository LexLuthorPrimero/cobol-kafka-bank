#!/usr/bin/env bash
set -euo pipefail

echo "=== EVENT INJECTION ==="

for i in $(seq 1 50); do
  echo "EVT_$i" >> accounts/queues/A.queue
  echo "EVT_$i" >> accounts/queues/B.queue
  echo "EVT_$i" >> accounts/queues/C.queue
done

echo "[OK] EVENTS DISTRIBUTED ACROSS TENANTS"
