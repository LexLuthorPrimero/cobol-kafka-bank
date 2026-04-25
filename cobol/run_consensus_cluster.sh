#!/usr/bin/env bash
set -euo pipefail

echo "=== CONSENSUS CLUSTER SYSTEM ==="

./hard_reset.sh

./leader_election.sh
./leader_writer.sh

./consensus_log.sh
./replicate_consensus.sh

./rebuild_from_consensus.sh

./heartbeat_check.sh || ./failover_leader.sh

echo "[OK] STRONGLY CONSISTENT DISTRIBUTED SYSTEM"
