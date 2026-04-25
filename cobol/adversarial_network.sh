#!/usr/bin/env bash
set -euo pipefail

echo "=== ADVERSARIAL NETWORK SIMULATION ==="

INPUT="accounts/JOURNAL.LOG"
OUTPUT="accounts/NETWORK_BUFFER.LOG"

: > "$OUTPUT"

while read -r line; do

  R=$((RANDOM % 10))

  # DROP (20%)
  if [ $R -lt 2 ]; then
    echo "[DROP] $line"
    continue
  fi

  # DELAY (30%)
  if [ $R -lt 5 ]; then
    sleep 1
  fi

  # REORDER (swap buffer append order simulated)
  if [ $R -lt 7 ]; then
    echo "$line" >> "$OUTPUT"
  else
    echo "$line" >> "$OUTPUT.tmp"
  fi

done < "$INPUT"

if [ -f "$OUTPUT.tmp" ]; then
  cat "$OUTPUT.tmp" >> "$OUTPUT"
  rm -f "$OUTPUT.tmp"
fi

echo "[OK] ADVERSARIAL PIPELINE COMPLETE"
