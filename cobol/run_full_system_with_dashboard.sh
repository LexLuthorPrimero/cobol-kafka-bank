#!/usr/bin/env bash
set -euo pipefail

echo "=== FULL SYSTEM + DASHBOARD ==="

./run_safe_cluster.sh

./observability_log.sh

./watch_dashboard.sh
