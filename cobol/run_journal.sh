#!/bin/bash

echo "=== JOURNAL + COMMIT ENGINE ==="

set -e

./reset_env.sh

cobc -x -free -o engine_journal_v1 engine_journal_v1.cob

./engine_journal_v1

echo "[RESULT ACCOUNTS]"
cat accounts/ACCOUNTS.DAT

echo "[JOURNAL]"
cat accounts/JOURNAL.LOG

echo "=== DONE ==="
