#!/usr/bin/env bash
set -euo pipefail

echo "=== NETWORK PARTITION SIMULATOR ==="

mkdir -p partitions

echo "A B" > partitions/cluster_majority
echo "C"   > partitions/cluster_isolated

echo "[PARTITION] A-B | C CREATED"
