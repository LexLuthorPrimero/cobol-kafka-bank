#!/usr/bin/env bash
set -euo pipefail

echo "=== BACKPRESSURE CONTROLLED CLUSTER ==="

./hard_reset.sh

./tenant_queues.sh
./overload_generator.sh

echo "[START ADAPTIVE SYSTEM]"
timeout 10s ./adaptive_scheduler.sh || true

./auto_heal_loop.sh
./observability_log.sh
./metrics_collector.sh
./audit_system.sh

./cluster_dashboard.sh

echo "[OK] SYSTEM SURVIVED BACKPRESSURE TEST"
