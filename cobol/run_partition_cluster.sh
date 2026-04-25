#!/usr/bin/env bash
set -euo pipefail

echo "=== PARTITION RESILIENT CLUSTER ==="

./hard_reset.sh

./leader_election.sh
./leader_writer.sh

./network_partition.sh

./split_brain_detector.sh
./enforce_fencing.sh

./consensus_log.sh
./replicate_consensus.sh
./rebuild_from_consensus.sh

./observability_log.sh
./metrics_collector.sh
./audit_system.sh

./cluster_dashboard.sh

echo "[OK] SYSTEM STABLE AFTER PARTITION EVENT"
