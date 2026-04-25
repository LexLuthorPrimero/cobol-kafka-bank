#!/usr/bin/env bash
set -euo pipefail

echo "=== SECURE SCHEDULER ==="

for Q in A B C; do

  FILE="accounts/queues/$Q.queue"

  if [ -s "$FILE" ]; then
    read -r EVENT < "$FILE"
    sed -i '1d' "$FILE"

    SAFE_EVENT=$(./security_gatekeeper.sh "$EVENT" || true)

    if [ -n "$SAFE_EVENT" ]; then
      ./sandbox_executor.sh "$SAFE_EVENT" "$Q"
    fi

  fi

done
