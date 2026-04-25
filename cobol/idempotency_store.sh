#!/usr/bin/env bash
set -euo pipefail

STORE="accounts/IDEMPOTENCY.DB"
mkdir -p accounts
touch "$STORE"

is_seen() {
  grep -q "$1" "$STORE" 2>/dev/null
}

mark_seen() {
  echo "$1" >> "$STORE"
}
