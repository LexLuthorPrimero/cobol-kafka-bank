#!/bin/bash

echo "=== SNAPSHOT SISTEMA COBOL ==="

echo ""
echo "[ARCHIVOS]"
ls -la accounts/ 2>/dev/null || echo "sin accounts/"
ls -la *.cob *.sh 2>/dev/null

echo ""
echo "[CUENTAS]"
cat accounts/ACCOUNTS.DAT 2>/dev/null || echo "sin datos"

echo ""
echo "[TRANS]"
cat trans_input.txt 2>/dev/null || echo "sin trans"

echo ""
echo "[ULTIMA EJECUCION]"
./procesa_transaccion

echo ""
echo "=== FIN SNAPSHOT ==="
