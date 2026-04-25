#!/bin/bash

echo "=== ENGINE V2 JOURNAL ==="

set -e

./reset_atomic.sh

cobc -x -free -o engine_v2_journal engine_v2_journal.cob

./engine_v2_journal

echo "=== JOURNAL OUTPUT ==="
cat accounts/JOURNAL.LOG
