#!/usr/bin/env bash
set -euo pipefail

echo "=== TENANT QUEUES INIT ==="

mkdir -p accounts/queues

touch accounts/queues/A.queue
touch accounts/queues/B.queue
touch accounts/queues/C.queue

echo "[OK] QUEUES READY"
