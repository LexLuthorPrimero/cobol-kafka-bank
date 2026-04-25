#!/usr/bin/env bash
set -euo pipefail

JOURNAL="accounts/JOURNAL.LOG"

P1="accounts/partition_00001.tmp"
P2="accounts/partition_others.tmp"

> "$P1"
> "$P2"

while IFS= read -r line; do

  IFS='|' read -r VERSION STATUS ACC_ID AMOUNT <<< "$line"

  if [ "$VERSION" != "V1" ]; then
    continue
  fi

  if [ "$ACC_ID" = "00001" ]; then
    echo "$line" >> "$P1"
  else
    echo "$line" >> "$P2"
  fi

done < "$JOURNAL"

echo "[OK] PARTITIONS CREATED"
