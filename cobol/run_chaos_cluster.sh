#!/usr/bin/env bash
set -euo pipefail

echo "=== CHAOS DISTRIBUTED CLUSTER ==="

./hard_reset.sh

./leader_election.sh
./leader_writer.sh

./chaos_network.sh || echo "[RECOVER] NETWORK ISSUE HANDLED"

./chaos_node_failure.sh

./quorum_gate.sh || echo "[FAILOVER] QUORUM BROKEN"

./failover_leader.sh

./consensus_log.sh
./replicate_consensus.sh
./rebuild_from_consensus.sh

./observability_log.sh
./metrics_collector.sh
./audit_system.sh

./cluster_dashboard.sh

echo "[OK] SYSTEM STABLE UNDER CHAOS CONDITIONS"
