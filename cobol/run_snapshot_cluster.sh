#!/usr/bin/env bash
set -euo pipefail

echo "=== SNAPSHOT-BASED DISTRIBUTED SYSTEM ==="

./hard_reset.sh

./leader_election.sh
./leader_writer.sh

./tx_coordinator.sh
./tx_executor.sh

./adversarial_network.sh
./safe_replay_engine.sh

./snapshot_create.sh

echo "[SIMULATE CRASH]"
rm -f accounts/ACCOUNTS.DAT

./crash_recovery.sh

./split_brain_detector.sh
./enforce_fencing.sh

./consensus_log.sh
./replicate_consensus.sh

./observability_log.sh
./metrics_collector.sh
./audit_system.sh

./cluster_dashboard.sh

echo "[OK] SYSTEM RECOVERED FROM SNAPSHOT"
