#!/usr/bin/env bash
set -euo pipefail

echo "=== SPLIT-BRAIN DETECTOR ==="

MAJ=$(wc -w < partitions/cluster_majority 2>/dev/null || echo 0)
MIN=$(wc -w < partitions/cluster_isolated 2>/dev/null || echo 0)

echo "MAJORITY SIZE: $MAJ"
echo "MINORITY SIZE: $MIN"

if [ "$MAJ" -gt "$MIN" ]; then
  echo "[OK] MAJORITY VALIDATED"
  echo "[FENCE] ISOLATING MINORITY NODE(S)"
else
  echo "[FATAL] NO SAFE QUORUM"
  exit 1
fi
