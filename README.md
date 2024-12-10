# 🚀 **Solana Development Container**

This container provides a Solana development environment, pre-installed with the Solana CLI, Anchor framework, Rust, Node.js, and other essential tools. It eliminates the need for local configuration, allowing you to focus on learning Anchor basics.

When starting off with anchor, the first hurdle is getting your contract to compile/ anchor to work.
This container does this for you building the example contract and having it ready for you to deploy.
When learning you mainly deal with two files:
Anchor.toml
lib.rs

you can edit lib.rs using emacs inside the container and then build your updated code.
The container is ready for your contract to be deployed, and at this point you will have to configure Anchor.toml

## ⚡ **Quickstart**

```bash
# Pull the latest image
docker pull hogyzen12/anchor-docker:latest

# Run with a new Solana keypair (recommended for testing)
docker run -it hogyzen12/anchor-docker:latest

Your shell will now be in the testbuild directory. 
This is the simple Hello example built and ready to deploy.
You will have to set up the Anchor.toml file with the network you want to deploy on - devnet is reccomended
```

---

## ✨ **Features**

- **Ubuntu 22.04**: Lightweight and reliable base image
- **Emacs**: Preinstalled text editor for further development
- **Rust Toolchain**: Pre-installed using `rustup` 
- **Solana CLI**: Built from source
- **Anchor CLI**: Installed for simplified Solana program development
- **Node.js 20.x**: Included for managing JavaScript-based dependencies and tools
- **Automated Key Management**: Support for both existing and new Solana keypairs
- Fully configured with essential libraries and dependencies for Solana development

---

## 🛠️ **Installation Options**

### **Option 1: Pull from Docker Registry (Recommended)**

This is the fastest way to get started:

1. Pull the container:
   ```bash
   docker pull hogyzen12/anchor-docker:latest
   ```

2. Run the container:
   - With a new keypair:
     ```bash
     docker run -it hogyzen12/anchor-docker:latest
     ```
   - With your existing keypair:
     ```bash
     docker run -v /path/to/your/id.json:/tmp/id.json -it hogyzen12/anchor-docker:latest /tmp/id.json
     ```

### **Option 2: Build from Source**

This option takes longer but allows for customization:

1. Clone the repository:
   ```bash
   git clone https://github.com/hogyzen12/anchor-docker.git
   cd anchor-docker
   ```

2. Build the Docker image - This is not quick:
   ```bash
   docker build -t anchor-docker:latest .
   ```

3. Run the container:
   - With a new keypair:
     ```bash
     docker run -it anchor-docker:latest
     ```
   - With your existing keypair:
     ```bash
     docker run -v /path/to/your/id.json:/tmp/id.json -it anchor-docker:latest /tmp/id.json
     ```

---

## 🔐 **Keypair Management**

### **Using an Existing Keypair**

If you have an existing Solana keypair:
1. Locate your `id.json` file (usually in `~/.config/solana/id.json`)
2. Mount it when running the container as shown above
3. The container will automatically configure Solana and anchor to use this keypair

### **Generating a New Keypair**

If you don't provide a keypair:
1. The container automatically generates a new keypair
2. The keypair is stored at `/usr/src/app/testbuild/id.json`
3. Solana CLI is automatically configured to use this keypair

---

## ✅ **Post-Setup Verification**

Verify your setup inside the container:

1. **Check Rust Installation**
   ```bash
   rustc --version
   cargo --version
   ```
   **Expected output:**
   ```
   rustc 1.75.0 (xx-xx-xxxx)
   cargo 1.xx.x (xx-xx-xxxx)
   ```

2. **Check Solana Installation**
   ```bash
   solana --version
   solana address  # Should show your keypair's address
   ```
   **Expected output:**
   ```
   solana-cli 1.18.26 (source)
   <your-solana-address>
   ```

3. **Check Anchor Installation**
   ```bash
   anchor --version
   ```
   **Expected output:**
   ```
   anchor-cli 0.30.1
   ```

4. **Check Node.js Installation**
   ```bash
   node -v
   npm -v
   ```
   **Expected output:**
   ```
   v20.x.x
   9.x.x
   ```

---

## 📖 **Common Commands**

### **Container Management**
```bash
# List running containers
docker ps

# Enter an existing container
docker exec -it <container_id_or_name> /bin/bash

# Stop the container
docker stop <container_id_or_name>

# Remove the container
docker rm <container_id_or_name>
```

### **Development Workflow**
```bash
# Create a new Anchor project
anchor init my_project

# Build your project
anchor build

# Run tests
anchor test

# Deploy your program
anchor deploy
```

---

## 🔄 **Updating the Container**

### **Pull the Latest Version**
```bash
docker pull hogyzen12/anchor-docker:latest
```

### **Rebuild from Source**
```bash
git pull  # Update your local repository
docker build -t anchor-docker:latest .
```

---

## 📝 **Notes**

- The container comes with a pre-initialized Anchor project at `/usr/src/app/testbuild`
- All necessary tools and dependencies are pre-installed and configured
- The container uses Rust 1.75.0 by default
- Your Solana keypair location will be automatically configured in the Solana CLI
- The container includes `emacs` for in-container development