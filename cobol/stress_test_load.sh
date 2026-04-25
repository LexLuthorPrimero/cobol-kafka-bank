#!/usr/bin/env bash
set -euo pipefail

echo "=== STRESS TEST LOAD GENERATOR ==="

JOURNAL="accounts/JOURNAL.LOG"

: > "$JOURNAL"

for i in $(seq 1 1000); do

  AMOUNT=$((RANDOM % 500))
  STATUS="OK"

  # degradación progresiva simulada
  if [ $i -gt 600 ]; then
    STATUS="FAIL"
  fi

  echo "V1|$STATUS|$i|$AMOUNT" >> "$JOURNAL"

  # presión progresiva
  if [ $i -gt 300 ]; then
    sleep 0.01
  fi

done

echo "[OK] LOAD GENERATED"
