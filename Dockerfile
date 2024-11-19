# Use Ubuntu as the base image
FROM ubuntu:22.04

# Set environment variables to prevent user prompts during installation
ENV DEBIAN_FRONTEND=noninteractive
ENV PATH="/root/.cargo/bin:${PATH}"

# Set the working directory inside the container
WORKDIR /usr/src/app

# Update package lists and install dependencies
RUN apt-get update && apt-get install -y \
    curl \
    build-essential \
    pkg-config \
    libssl-dev \
    libudev-dev \
    git \
    wget \
    clang \
    llvm \
    protobuf-compiler \
    cmake \
    libprotobuf-dev \
    perl \
    gcc \
    g++ \
    libclang-dev \
    && rm -rf /var/lib/apt/lists/*

# Install Rust using rustup
RUN curl https://sh.rustup.rs -sSf | sh -s -- -y

# Add cargo to PATH for this session
SHELL ["/bin/bash", "-c"]

# Verify Rust installation
RUN source $HOME/.cargo/env && \
    rustc --version && \
    cargo --version

# Copy Solana source code into the container
COPY solana-1.18.26 /usr/src/app/solana

# Build Solana from source
WORKDIR /usr/src/app/solana
RUN source $HOME/.cargo/env && \
    bash ./scripts/cargo-install-all.sh .

# Set Solana binaries in the PATH
ENV PATH="/usr/src/app/solana/bin:${PATH}"

# Verify Solana installation
RUN source $HOME/.cargo/env && \
    solana --version

# Set the entrypoint to bash
ENTRYPOINT ["/bin/bash"]