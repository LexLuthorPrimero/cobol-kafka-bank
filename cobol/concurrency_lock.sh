#!/bin/bash

echo "=== LOCK SIMPLE PARA CONCURRENCIA ==="

LOCK_FILE="accounts/LOCK"

acquire_lock() {
  while [ -f "$LOCK_FILE" ]; do
    echo "WAIT LOCK..."
    sleep 1
  done
  touch "$LOCK_FILE"
}

release_lock() {
  rm -f "$LOCK_FILE"
}

echo "LOCK SYSTEM READY"
