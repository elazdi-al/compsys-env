
# Use Ubuntu 20.04 LTS as base
FROM ubuntu:20.04

# Avoid interactive prompts during package installation
ENV DEBIAN_FRONTEND=noninteractive

# Update and install essential packages for a full C development environment
RUN apt-get update && apt-get install -y \
    clang \
    build-essential \
    neovim \
    git \
    curl \
    wget \
    openssh-server \
    sudo \
    cmake \
    ninja-build \
    gdb \
    valgrind \
    clang-format \
    clang-tidy \
    ccache \
 && rm -rf /var/lib/apt/lists/*

# Create a non-root user "dev" with password "dev" and grant sudo privileges
RUN useradd -ms /bin/bash dev && \
    echo "dev:dev" | chpasswd && \
    adduser dev sudo

# Set up SSH server configuration
RUN mkdir /var/run/sshd && \
    sed -i 's/#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config

# Switch to user "dev" for NVChad installation and workspace setup
USER dev
WORKDIR /home/dev

# Clone NVChad configuration (plugins will auto-install on first run)
RUN git clone https://github.com/NvChad/NvChad ~/.config/nvim --depth 1

# Create a workspace directory for your code
RUN mkdir -p /home/dev/workspace

# Switch back to root so that the SSH server can run
USER root

# Expose the SSH port
EXPOSE 22

# Start the SSH server when the container runs
CMD ["/usr/sbin/sshd", "-D"]
