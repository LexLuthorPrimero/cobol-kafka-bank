#!/usr/bin/env bash
set -euo pipefail

JOURNAL="accounts/JOURNAL.LOG"
OUTPUT="accounts/JOURNAL.COMPACTED"

echo "=== LOG COMPACTION ==="

declare -A LAST_AMOUNT
declare -A LAST_STATUS

while IFS='|' read -r VERSION STATUS ACC_ID AMOUNT; do

  if [ "$VERSION" != "V1" ]; then
    continue
  fi

  LAST_AMOUNT["$ACC_ID"]="$AMOUNT"
  LAST_STATUS["$ACC_ID"]="$STATUS"

done < "$JOURNAL"

> "$OUTPUT"

for ID in "${!LAST_AMOUNT[@]}"; do
  echo "V1|${LAST_STATUS[$ID]}|$ID|${LAST_AMOUNT[$ID]}" >> "$OUTPUT"
done

echo "[OK] JOURNAL COMPACTED"
