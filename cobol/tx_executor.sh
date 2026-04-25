#!/usr/bin/env bash
set -euo pipefail

echo "=== TX EXECUTOR ==="

while read -r TX STATUS; do

  if [ "$STATUS" = "COMMIT" ]; then
    echo "[APPLY] TX $TX COMMITTED"
  fi

  if [ "$STATUS" = "ROLLBACK" ]; then
    echo "[UNDO] TX $TX ROLLED BACK"
  fi

done < accounts/TX.LOG
