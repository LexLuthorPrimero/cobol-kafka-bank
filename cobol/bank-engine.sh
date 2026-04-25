#!/usr/bin/env bash
set -euo pipefail

MODE="${1:-help}"

case "$MODE" in

  run)
    echo "[MODE] PRODUCTION RUN"
    ./unified_orchestrator.sh
    ;;

  demo)
    echo "[MODE] DEMO SIMULATION"
    ./run_multitenant_cluster.sh
    ;;

  stress)
    echo "[MODE] STRESS TEST"
    ./run_stress_test.sh
    ;;

  recover)
    echo "[MODE] DISASTER RECOVERY"
    ./run_disaster_recovery_cluster.sh
    ;;

  secure)
    echo "[MODE] SECURE CLUSTER"
    ./run_secure_cluster.sh
    ;;

  cap)
    echo "[MODE] CAP SYSTEM"
    ./run_cap_cluster.sh
    ;;

  *)
    echo "USAGE:"
    echo "  ./bank-engine.sh run"
    echo "  ./bank-engine.sh demo"
    echo "  ./bank-engine.sh stress"
    echo "  ./bank-engine.sh recover"
    echo "  ./bank-engine.sh secure"
    echo "  ./bank-engine.sh cap"
    ;;
esac
