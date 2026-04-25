#!/bin/bash

echo "=== RESET COBOL BANK CLEAN CORE ==="

set -e

mkdir -p accounts

rm -rf accounts/*
rm -f trans_input.txt

cat <<EOT > accounts/ACCOUNTS.DAT
00001JUAN               000010000
EOT

cat <<EOT > trans_input.txt
00001 000000070
00001 000000030
EOT

echo "[OK] CLEAN STATE READY"
