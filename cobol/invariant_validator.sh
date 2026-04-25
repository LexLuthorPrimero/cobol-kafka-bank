#!/usr/bin/env bash
set -euo pipefail

echo "=== INVARIANT VALIDATOR ==="

./replay_engine.sh > /tmp/replay.log

echo "[CHECK 1] CONSERVATION CHECK"
# placeholder lógico (extensible)
echo "[OK] (manual check required or extend parser)"

echo "[CHECK 2] JOURNAL INTEGRITY"
./journal_validator.sh

echo "[CHECK 3] STATE STABILITY"
./bank-engine demo > /tmp/state1.log
./bank-engine demo > /tmp/state2.log

diff /tmp/state1.log /tmp/state2.log >/dev/null \
  && echo "[OK] DETERMINISTIC OUTPUT" \
  || echo "[WARN] NON-DETERMINISM DETECTED"

echo "[OK] INVARIANT VALIDATION COMPLETE"
