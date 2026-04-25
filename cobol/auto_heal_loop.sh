#!/usr/bin/env bash
set -euo pipefail

echo "=== AUTO-HEALING LOOP ==="

./anomaly_detector.sh || {
  echo "[RECOVERY MODE ACTIVATED]"
  ./healing_controller.sh
}

./metrics_collector.sh
./audit_system.sh

echo "[OK] SYSTEM STABILIZED"
