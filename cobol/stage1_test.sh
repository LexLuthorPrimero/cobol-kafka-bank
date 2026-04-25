#!/bin/bash

echo "=== STAGE 1 TEST MULTI TRANS ==="

set -e

./reset_env.sh

echo ""
echo "[BUILD]"
cobc -x -free -o procesa_transaccion stage1_batch_upgrade.cob

echo ""
echo "[INPUT BASE]"
cat accounts/ACCOUNTS.DAT

echo ""
echo "[TRANSACCIONES]"
cat > trans_input.txt << EOT
00001 000000050
00001 000000120
00001 000000030
EOT

echo ""
echo "[RUN]"
./procesa_transaccion

echo ""
echo "[RESULT]"
cat accounts/ACCOUNTS.DAT

echo "=== END STAGE 1 TEST ==="
