#!/bin/bash

echo "=== CICLO COMPLETO DE TRANSACCIONES ==="

mkdir -p accounts

# estado inicial
echo "00001JUAN               000010000" > accounts/ACCOUNTS.DAT

# múltiples transacciones simuladas
echo "00001 000000100" > trans_input.txt

echo "--- RUN 1 ---"
./procesa_transaccion
./patch_swap.sh

echo "--- ESTADO POST 1 ---"
cat accounts/ACCOUNTS.DAT

# segunda transacción
echo "00001 000000300" > trans_input.txt

echo "--- RUN 2 ---"
./procesa_transaccion
./patch_swap.sh

echo "--- ESTADO FINAL ---"
cat accounts/ACCOUNTS.DAT

echo "=== DONE ==="
