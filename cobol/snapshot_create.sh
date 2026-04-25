#!/usr/bin/env bash
set -euo pipefail

echo "=== SNAPSHOT CREATION ==="

mkdir -p accounts/snapshots

SNAPSHOT="accounts/snapshots/snapshot.dat"

cp accounts/ACCOUNTS.DAT "$SNAPSHOT"

echo "$(date +%s)" > accounts/snapshots/LAST_SNAPSHOT_TIME

echo "[OK] SNAPSHOT CREATED"
