#!/bin/bash
echo "{\"id\": $1, \"monto\": $2}" > inbox/tx-$(date +%s).json
