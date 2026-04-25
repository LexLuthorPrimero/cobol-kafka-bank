#!/usr/bin/env bash
set -euo pipefail

echo "=== CONTROL LOOP START ==="

for i in $(seq 1 10); do

  echo "---- CYCLE $i ----"

  ./metrics_collector.sh
  ./health_check.sh

  ./decision_engine.sh
  ./system_actuator.sh

  ./secure_scheduler.sh || true
  ./auto_heal_loop.sh || true

done

echo "=== CONTROL LOOP END ==="
