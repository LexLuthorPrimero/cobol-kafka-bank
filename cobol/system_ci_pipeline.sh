#!/usr/bin/env bash
set -euo pipefail

echo "===================================="
echo "     SYSTEM CI PIPELINE START       "
echo "===================================="

echo "[1] BUILD PHASE"
./install.sh

echo "[2] BASE EXECUTION TEST"
./bank-engine demo > /tmp/ci_run.log

echo "[3] STRESS PHASE"
./bank-engine stress > /tmp/ci_stress.log || true

echo "[4] FAILURE SIMULATION"
./catastrophic_failure.sh || true

echo "[5] RECOVERY PHASE"
./multi_layer_recovery.sh

echo "[6] VALIDATION PHASE"
./system_test_harness.sh

echo "===================================="
echo "        CI PIPELINE DONE            "
echo "===================================="
