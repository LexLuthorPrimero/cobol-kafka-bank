#!/bin/bash

echo "=== HARD RESET COBOL BANK (STRICT CLEAN) ==="

set -e

mkdir -p accounts

# eliminar TODO sin excepción
rm -rf accounts/*
rm -f trans_input.txt

# recrear estado base limpio
cat <<EOT > accounts/ACCOUNTS.DAT
00001JUAN               000010000
EOT

# input válido
cat <<EOT > trans_input.txt
00001 000000070
EOT

echo "[OK] ENTORNO LIMPIO (ZERO CORRUPTION STATE)"
