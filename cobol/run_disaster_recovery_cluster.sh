#!/usr/bin/env bash
set -euo pipefail

echo "=== DISASTER RECOVERY SIMULATION ==="

./hard_reset.sh

./tenant_queues.sh
./inject_tenant_events.sh

./safe_replay_engine.sh
./observability_log.sh

echo "[TRIGGER CATASTROPHE]"
./catastrophic_failure.sh

echo "[DETECT DAMAGE]"
./system_damage_detector.sh

echo "[RECOVERY START]"
./multi_layer_recovery.sh

./auto_heal_loop.sh
./metrics_collector.sh
./audit_system.sh
./cluster_dashboard.sh

echo "[OK] FULL SYSTEM RECOVERED FROM CATASTROPHE"
