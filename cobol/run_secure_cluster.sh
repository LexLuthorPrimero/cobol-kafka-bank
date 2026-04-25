#!/usr/bin/env bash
set -euo pipefail

echo "=== SECURE DISTRIBUTED CLUSTER ==="

./hard_reset.sh

./tenant_queues.sh
./inject_tenant_events.sh

echo "[START SECURE EXECUTION]"

for i in $(seq 1 20); do
  ./cap_mode_controller.sh
  ./secure_scheduler.sh
  ./auto_heal_loop.sh
done

./observability_log.sh
./metrics_collector.sh
./audit_system.sh

./cluster_dashboard.sh

echo "[OK] SECURE CLUSTER COMPLETE"
