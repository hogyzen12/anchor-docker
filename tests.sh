#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

# Build the Docker image
docker build -t anchor-docker:latest .

# Run the container and execute a series of commands
docker run --rm anchor-docker:latest bash -c "
    anchor --version &&
    solana --version &&
    rustc --version &&
    cargo --version &&
    node --version &&
    npm --version
"

echo "All tools are installed and functioning properly."
