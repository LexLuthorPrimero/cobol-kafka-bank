#!/bin/bash

./concurrency_lock.sh
source ./concurrency_lock.sh

acquire_lock

echo "SWAP ATOMICO"

mv accounts/TEMP.DAT accounts/ACCOUNTS.DAT

release_lock

echo "OK SWAP DONE"
