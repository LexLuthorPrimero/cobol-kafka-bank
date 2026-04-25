#!/usr/bin/env bash
set -euo pipefail

echo "=== AUTO FAILOVER CLUSTER ==="

./hard_reset.sh

./leader_election.sh
./leader_writer.sh
./leader_replication.sh

./heartbeat_check.sh || ./failover_leader.sh

./leader_writer.sh
./leader_replication.sh

./quorum_validator.sh
./snapshot_worker_00001.sh

echo "[OK] SELF-HEALING CLUSTER STABLE"
