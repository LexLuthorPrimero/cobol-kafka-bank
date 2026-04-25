#!/usr/bin/env bash
set -euo pipefail

echo "=== MULTI-TENANT DISTRIBUTED SYSTEM ==="

./hard_reset.sh

./tenant_queues.sh
./inject_tenant_events.sh

echo "[START SCHEDULER]"
timeout 10s ./fair_scheduler.sh || true

./observability_log.sh
./metrics_collector.sh
./audit_system.sh

./cluster_dashboard.sh

echo "[OK] MULTI-TENANT EXECUTION COMPLETE"
