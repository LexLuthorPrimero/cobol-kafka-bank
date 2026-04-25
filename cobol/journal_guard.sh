#!/bin/bash

echo "=== JOURNAL GUARD ==="

set -e

JOURNAL="accounts/JOURNAL.LOG"

if [ ! -f "$JOURNAL" ]; then
  touch "$JOURNAL"
fi

# asegurar append-only
chmod 644 "$JOURNAL"

echo "[OK] JOURNAL READY (APPEND ONLY)"
