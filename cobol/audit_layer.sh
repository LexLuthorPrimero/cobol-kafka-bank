#!/bin/bash

echo "=== AUDIT LAYER COBOL BANK ==="

mkdir -p audit

# wrapper de ejecución con log simple
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
LOG="audit/run_$TIMESTAMP.log"

echo "INIT AUDIT $TIMESTAMP" > "$LOG"

echo "" >> "$LOG"
echo "[BEFORE]" >> "$LOG"
cat accounts/ACCOUNTS.DAT >> "$LOG" 2>/dev/null || echo "NO ACCOUNTS" >> "$LOG"

echo "" >> "$LOG"
echo "[TRANSACTION INPUT]" >> "$LOG"
cat trans_input.txt >> "$LOG" 2>/dev/null || echo "NO TRANS" >> "$LOG"

echo "" >> "$LOG"
echo "[EXECUTION]" >> "$LOG"
./procesa_transaccion >> "$LOG"

echo "" >> "$LOG"
echo "[AFTER]" >> "$LOG"
cat accounts/ACCOUNTS.DAT >> "$LOG" 2>/dev/null || echo "NO ACCOUNTS" >> "$LOG"

echo "END AUDIT" >> "$LOG"

echo "OK AUDIT SAVED -> $LOG"
