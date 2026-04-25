#!/usr/bin/env bash
set -euo pipefail

echo "=== UNIFIED DISTRIBUTED SYSTEM ==="

./hard_reset.sh

./tenant_queues.sh
./inject_tenant_events.sh

for i in $(seq 1 15); do

  echo "---- CYCLE $i ----"

  ./security_gatekeeper.sh "SAFE_EVENT" >/dev/null 2>&1 || true
  ./cap_mode_controller.sh >/dev/null 2>&1 || true
  ./backpressure_monitor.sh >/dev/null 2>&1 || true

  ./secure_scheduler.sh
  ./auto_heal_loop.sh

done

./observability_log.sh
./metrics_collector.sh
./audit_system.sh
./resilience_report.sh

./cluster_dashboard.sh

echo "[OK] SYSTEM READY (PRODUCTION-GRADE SIMULATION)"
