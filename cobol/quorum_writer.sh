#!/usr/bin/env bash
set -euo pipefail

EVENT="V1|OK|00001|70"

A="accounts/JOURNAL.LOG"
B="accounts/JOURNAL_REPLICA_1.LOG"
C="accounts/JOURNAL_REPLICA_2.LOG"

echo "=== QUORUM WRITE ==="

SUCCESS=0

write_node() {
  echo "$EVENT" >> "$1" && echo 1 || echo 0
}

SUCCESS=$((SUCCESS + $(write_node "$A")))
SUCCESS=$((SUCCESS + $(write_node "$B")))
SUCCESS=$((SUCCESS + $(write_node "$C")))

echo "ACKS: $SUCCESS"

if [ "$SUCCESS" -ge 2 ]; then
  echo "[COMMIT] QUORUM ACHIEVED"
else
  echo "[FAIL] QUORUM NOT REACHED"
  exit 1
fi
