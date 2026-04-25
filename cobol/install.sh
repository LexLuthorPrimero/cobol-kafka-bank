#!/usr/bin/env bash
set -euo pipefail

echo "[INSTALL] Preparing system..."

chmod +x bank-engine
chmod +x *.sh
chmod +x core/*.sh
chmod +x modes/*.sh
chmod +x security/*.sh
chmod +x recovery/*.sh
chmod +x observability/*.sh

echo "[OK] SYSTEM READY"
echo "Run: ./bank-engine demo"
