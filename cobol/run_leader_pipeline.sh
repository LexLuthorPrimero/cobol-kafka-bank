#!/usr/bin/env bash
set -euo pipefail

echo "=== LEADER-BASED DISTRIBUTED SYSTEM ==="

./hard_reset.sh

./leader_election.sh
./leader_writer.sh
./leader_replication.sh

./quorum_validator.sh
./snapshot_worker_00001.sh

echo "[OK] SINGLE WRITER CLUSTER STABLE"
