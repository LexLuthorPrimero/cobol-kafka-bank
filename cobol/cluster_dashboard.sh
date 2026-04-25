#!/usr/bin/env bash
set -euo pipefail

echo "=========================="
echo "   CLUSTER DASHBOARD      "
echo "=========================="

./health_check.sh
./metrics_collector.sh

echo "=========================="
echo "STATUS: OPERATIONAL"
echo "=========================="
