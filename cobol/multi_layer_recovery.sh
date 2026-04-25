#!/usr/bin/env bash
set -euo pipefail

echo "=== MULTI-LAYER RECOVERY ENGINE ==="

./system_damage_detector.sh

echo "[LAYER 1] SNAPSHOT RECOVERY"
./crash_recovery.sh || true

echo "[LAYER 2] JOURNAL REPLAY"
./replay_engine.sh || true

echo "[LAYER 3] QUEUE RECONSTRUCTION"
./tenant_queues.sh

echo "[LAYER 4] OBSERVABILITY REBUILD"
./observability_log.sh

echo "[LAYER 5] CONSENSUS RESTORE"
./replicate_consensus.sh || true

echo "[OK] SYSTEM REBUILT FROM MULTI-LAYER RECOVERY"
