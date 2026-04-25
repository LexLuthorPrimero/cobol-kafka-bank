#!/usr/bin/env bash
set -euo pipefail

echo "=== ACID DISTRIBUTED CLUSTER ==="

./hard_reset.sh

./leader_election.sh
./leader_writer.sh

./tx_coordinator.sh
./tx_executor.sh

./adversarial_network.sh
./safe_replay_engine.sh

./split_brain_detector.sh
./enforce_fencing.sh

./consensus_log.sh
./replicate_consensus.sh
./rebuild_from_consensus.sh

./observability_log.sh
./metrics_collector.sh
./audit_system.sh

./cluster_dashboard.sh

echo "[OK] ACID CONSISTENCY ACHIEVED"
