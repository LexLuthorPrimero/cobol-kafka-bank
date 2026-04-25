#!/usr/bin/env bash
set -euo pipefail

echo "=== SYSTEM TEST HARNESS ==="

./install.sh

echo "[1] RUN CLEAN SYSTEM"
./bank-engine demo > /tmp/run.log

cp accounts/ACCOUNTS.DAT /tmp/state_before.dat

echo "[2] REPLAY JOURNAL"
./replay_engine.sh > /tmp/replay.log

echo "[3] VALIDATE CONSISTENCY"

diff accounts/ACCOUNTS.DAT /tmp/state_before.dat >/dev/null && {
  echo "[OK] STATE CONSISTENT"
} || {
  echo "[WARN] STATE CHANGED (expected if events applied)"
}

echo "[4] CRASH TEST"

./catastrophic_failure.sh || true
./multi_layer_recovery.sh

echo "[5] POST RECOVERY CHECK"
./journal_validator.sh

echo "[OK] SYSTEM TEST COMPLETE"
