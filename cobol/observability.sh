#!/bin/bash

echo "=== OBSERVABILIDAD COBOL BANK ==="

mkdir -p metrics

TS=$(date +%s)
OUT="metrics/metrics_$TS.log"

echo "timestamp=$TS" > "$OUT"

echo "accounts_size=$(wc -l < accounts/ACCOUNTS.DAT 2>/dev/null || echo 0)" >> "$OUT"
echo "trans_present=$(test -f trans_input.txt && echo 1 || echo 0)" >> "$OUT"

echo "" >> "$OUT"
echo "[RUN]" >> "$OUT"
./procesa_transaccion >> "$OUT"

echo "" >> "$OUT"
echo "[STATE]" >> "$OUT"
cat accounts/ACCOUNTS.DAT >> "$OUT" 2>/dev/null || echo "NO DATA" >> "$OUT"

echo "OK METRICS -> $OUT"
