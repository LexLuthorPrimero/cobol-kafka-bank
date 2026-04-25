#!/bin/bash

echo "=== HARD RESET COBOL SAFE STATE ==="

set -e

mkdir -p accounts

# eliminar TODO sin excepción real
rm -f accounts/JOURNAL.LOG
rm -f accounts/TEMP.DAT
rm -f accounts/ACCOUNTS.DAT
rm -f trans_input.txt

# recrear SOLO inputs
echo "00001JUAN               000010000" > accounts/ACCOUNTS.DAT
echo "00001 000000070" > trans_input.txt

echo "[OK] PURE STATE (NO JOURNAL CREATED)"
