#!/bin/bash

echo "=== ATOMIC RESET (NO CORRUPTION GUARANTEE) ==="

set -e

mkdir -p accounts

# eliminar todo rastro físico
rm -rf accounts/*
rm -f trans_input.txt

# SOLO datos base
cat <<EOT > accounts/ACCOUNTS.DAT
00001JUAN               000010000
EOT

cat <<EOT > trans_input.txt
00001 000000070
EOT

echo "[OK] CLEAN ATOMIC STATE READY"
