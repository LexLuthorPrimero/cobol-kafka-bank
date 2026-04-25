#!/bin/bash

set -e

cobc -x -free -o procesa_transaccion engine_v2_transactions.cob

./procesa_transaccion
