#!/bin/bash

echo "=== MONITOR BANCO COBOL ==="

echo ""
echo ">> ESTADO CUENTAS:"
cat accounts/ACCOUNTS.DAT 2>/dev/null || echo "SIN DATOS"

echo ""
echo ">> ULTIMA TRANSACCION:"
cat trans_input.txt 2>/dev/null || echo "SIN TRANSACCIONES"

echo ""
echo ">> BINARIO:"
ls -l procesa_transaccion 2>/dev/null || echo "NO COMPILADO"

echo ""
echo "=== END ==="
