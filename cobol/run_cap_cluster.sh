#!/usr/bin/env bash
set -euo pipefail

echo "=== CAP DYNAMIC DISTRIBUTED SYSTEM ==="

./hard_reset.sh

./tenant_queues.sh
./overload_generator.sh

for i in $(seq 1 20); do

  ./cap_mode_controller.sh
  ./cap_executor.sh
  ./auto_heal_loop.sh

done

./observability_log.sh
./metrics_collector.sh
./resilience_report.sh
./audit_system.sh

./cluster_dashboard.sh

echo "[OK] CAP DYNAMIC SYSTEM COMPLETE"
