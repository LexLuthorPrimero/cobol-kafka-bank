#!/usr/bin/env bash
set -euo pipefail

A="accounts/JOURNAL.LOG"
B="accounts/JOURNAL_REPLICA_1.LOG"
C="accounts/JOURNAL_REPLICA_2.LOG"

echo "=== QUORUM CONSISTENCY CHECK ==="

A_L=$(wc -l < "$A" 2>/dev/null || echo 0)
B_L=$(wc -l < "$B" 2>/dev/null || echo 0)
C_L=$(wc -l < "$C" 2>/dev/null || echo 0)

echo "A:$A_L B:$B_L C:$C_L"

MAX=$(( A_L > B_L ? A_L : B_L ))
MAX=$(( MAX > C_L ? MAX : C_L ))

DIFF_A=$((MAX - A_L))
DIFF_B=$((MAX - B_L))
DIFF_C=$((MAX - C_L))

if [ "$DIFF_A" -le 1 ] && [ "$DIFF_B" -le 1 ] && [ "$DIFF_C" -le 1 ]; then
  echo "[OK] EVENTUAL CONSISTENCY OK"
else
  echo "[WARN] DIVERGENCE DETECTED"
fi
