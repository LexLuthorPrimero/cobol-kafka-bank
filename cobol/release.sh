#!/usr/bin/env bash
set -euo pipefail

echo "===================================="
echo "      COBOL-KAFKA BANK ENGINE       "
echo "            RELEASE 1.0             "
echo "===================================="

echo "[STEP 1] INSTALL"
./install.sh

echo "[STEP 2] CLEAN START"
./bank-engine demo > /tmp/demo_run.log || true

echo "[STEP 3] STRESS TEST"
./bank-engine stress > /tmp/stress.log || true

echo "[STEP 4] FAILURE SIMULATION"
./catastrophic_failure.sh || true

echo "[STEP 5] RECOVERY"
./multi_layer_recovery.sh

echo "[STEP 6] INVARIANT VALIDATION"
./system_test_harness.sh

echo "[STEP 7] CI PIPELINE"
./system_ci_pipeline.sh

echo "[STEP 8] OBSERVABILITY"
./cluster_dashboard.sh

echo "===================================="
echo "          RELEASE COMPLETE          "
echo "===================================="
