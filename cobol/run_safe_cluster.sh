#!/usr/bin/env bash
set -euo pipefail

echo "=== SAFE DISTRIBUTED CLUSTER ==="

./hard_reset.sh

./leader_election.sh
./leader_writer.sh

./quorum_gate.sh
./fencing.sh

./consensus_log.sh
./replicate_consensus.sh
./rebuild_from_consensus.sh

./heartbeat_check.sh || ./failover_leader.sh

echo "[OK] SPLIT-BRAIN PROTECTED SYSTEM STABLE"
