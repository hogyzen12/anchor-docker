# Use Ubuntu as the base image
FROM --platform=linux/amd64 ubuntu:22.04

# Set environment variables to prevent user prompts during installation
ENV DEBIAN_FRONTEND=noninteractive
ENV PATH="/root/.cargo/bin:${PATH}"
ENV PLATFORM_TOOLS_VERSION=v1.43
ENV PLATFORM_TOOLS_ARCH=x86_64

# Add build argument for Anchor version
ARG ANCHOR_VERSION=v0.30.1
ARG SOLANA_PRIVATE_KEY=""

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
    emacs \
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

# Install Anchor CLI with specified version
RUN source $HOME/.cargo/env && \
    cargo install --git https://github.com/coral-xyz/anchor --tag ${ANCHOR_VERSION} anchor-cli --locked

# Pre-download platform tools
RUN mkdir -p ~/.local/share/platform-tools && \
    cd ~/.local/share/platform-tools && \
    wget https://github.com/anza-xyz/platform-tools/releases/download/v1.43/platform-tools-linux-x86_64.tar.bz2 && \
    tar -xjf platform-tools-linux-x86_64.tar.bz2 && \
    rm platform-tools-linux-x86_64.tar.bz2

# Add platform tools to PATH
ENV PATH="/root/.local/share/platform-tools/platform-tools/bin:${PATH}"

# Verify Anchor installation
RUN source $HOME/.cargo/env && \
    anchor --version

# Install Node.js 20.x
RUN curl -fsSL https://deb.nodesource.com/setup_20.x | bash - \
    && apt-get install -y nodejs \
    && npm install -g npm@latest \
    && rm -rf /var/lib/apt/lists/*

RUN cd /usr/src/app/ && \
    anchor init testbuild && \
    cd testbuild

RUN rustup install 1.75.0
RUN rustup default 1.75.0
RUN rm Cargo.lock && cargo clean && cargo generate-lockfile

RUN cd /usr/src/app/testbuild && anchor build
# Extract program ID and update lib.rs (fixed escaping)
RUN cd /usr/src/app/testbuild && \
    PROGRAM_ID=$(anchor keys list | grep -oP "(?<=: ).*") && \
    find ./programs -name "lib.rs" -exec sed -i 's/declare_id!("[^"]*")/declare_id!("'"$PROGRAM_ID"'")/' {} \;

# Copy the entrypoint script
COPY docker-entrypoint.sh /usr/src/app/
RUN chmod +x /usr/src/app/docker-entrypoint.sh

# Set final working directory to testbuild
WORKDIR /usr/src/app/testbuild

# Use the entrypoint script
ENTRYPOINT ["/usr/src/app/docker-entrypoint.sh"]