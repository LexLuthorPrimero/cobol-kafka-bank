#!/usr/bin/env bash
set -euo pipefail

echo "=== DISTRIBUTED SYSTEM STRESS TEST ==="

./hard_reset.sh

./stress_test_load.sh

echo "[PHASE 1] PROCESSING LOAD"
./safe_replay_engine.sh

echo "[PHASE 2] OBSERVABILITY"
./observability_log.sh

echo "[PHASE 3] AUTO HEAL CHECK"
./auto_heal_loop.sh

echo "[PHASE 4] SNAPSHOT RECOVERY CHECK"
./snapshot_create.sh

echo "[PHASE 5] FINAL VALIDATION"
./audit_system.sh

echo "[OK] STRESS TEST COMPLETE"
