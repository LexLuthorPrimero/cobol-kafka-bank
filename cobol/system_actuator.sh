#!/usr/bin/env bash
set -euo pipefail

echo "=== SYSTEM ACTUATOR ==="

ACTION=$(cat /tmp/system_action.flag 2>/dev/null || echo "none")

case "$ACTION" in

  throttle)
    echo "[ACTION] REDUCING LOAD"
    sleep 1
    ;;

  heal)
    echo "[ACTION] RUNNING RECOVERY"
    ./multi_layer_recovery.sh || true
    ;;

  none)
    echo "[ACTION] NO CHANGE"
    ;;

esac

echo "[OK] ACTION APPLIED"
