#!/bin/bash

# Check if a key file was provided as an argument
if [ -n "$1" ] && [ -f "$1" ]; then
    # Copy the provided key to the target location
    mkdir -p /usr/src/app/testbuild
    cp "$1" /usr/src/app/testbuild/id.json
    echo "Using provided Solana key"
else
    # Generate new key if none provided
    mkdir -p /usr/src/app/testbuild
    solana-keygen new --no-bip39-passphrase -o /usr/src/app/testbuild/id.json
    echo "Generated new Solana key"
fi

# Set the Solana config to use this key
solana config set -k /usr/src/app/testbuild/id.json

# Execute the command passed to docker run or fall back to bash
exec "${@:-bash}"