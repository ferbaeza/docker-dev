FROM ollama/ollama:latest

ARG PUID=1000
ARG PGID=1000

ENV DEBIAN_FRONTEND=noninteractive

# Install common dependencies and Node.js
RUN apt-get update && apt-get install -y \
    curl \
    git \
    sudo \
    nodejs \
    npm \
    && rm -rf /var/lib/apt/lists/*

# User setup
RUN if getent group ${PGID}; then \
        groupmod -n opencodeuser $(getent group ${PGID} | cut -d: -f1); \
    else \
        groupadd -g ${PGID} opencodeuser; \
    fi && \
    if getent passwd ${PUID}; then \
        usermod -l opencodeuser -m -d /home/opencodeuser $(getent passwd ${PUID} | cut -d: -f1); \
    else \
        useradd -u ${PUID} -g ${PGID} -m -s /bin/bash opencodeuser; \
    fi && \
    echo "opencodeuser ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# Copy the custom entrypoint script
COPY entrypoint.sh /usr/local/bin/custom_entrypoint.sh
RUN chmod +x /usr/local/bin/custom_entrypoint.sh

# Set permissions for the Ollama data directory as root
RUN mkdir -p /home/opencodeuser/.ollama && \
    chown -R opencodeuser:opencodeuser /home/opencodeuser/.ollama && \
    chmod -R 700 /home/opencodeuser/.ollama

# Set permissions for the OpenCode config directory as root
RUN mkdir -p /home/opencodeuser/.config/opencode && \
    chown -R opencodeuser:opencodeuser /home/opencodeuser/.config/opencode && \
    chmod -R 700 /home/opencodeuser/.config/opencode

# Set permissions for the OpenCode local state directory as root
RUN mkdir -p /home/opencodeuser/.local && \
    chown -R opencodeuser:opencodeuser /home/opencodeuser/.local && \
    chmod -R 777 /home/opencodeuser/.local

# Copy default OpenCode config with Ollama provider preconfigured
COPY opencode.json /home/opencodeuser/.config/opencode/opencode.json
RUN chown opencodeuser:opencodeuser /home/opencodeuser/.config/opencode/opencode.json

# Pre-configure auth placeholder for Ollama (no real API key needed)
RUN mkdir -p /home/opencodeuser/.local/share/opencode && \
    echo '{"ollama":{"type":"api","key":"ollama"}}' > /home/opencodeuser/.local/share/opencode/auth.json && \
    chown -R opencodeuser:opencodeuser /home/opencodeuser/.local/share/opencode

# Ensure state directory exists for OpenCode
RUN mkdir -p /home/opencodeuser/.local/state && \
    chown -R opencodeuser:opencodeuser /home/opencodeuser/.local/state && \
    chmod -R 777 /home/opencodeuser/.local/state

# Add opencode to global PATH for all users
RUN echo 'export PATH="/home/opencodeuser/.opencode/bin:$PATH"' > /etc/profile.d/opencode.sh

USER opencodeuser
WORKDIR /home/opencodeuser

# Install OpenCode
RUN curl -fsSL https://opencode.ai/install | bash

# Add opencode to PATH for the container
ENV PATH="/home/opencodeuser/.opencode/bin:${PATH}"

WORKDIR /workspace

# Set the custom entrypoint
ENTRYPOINT ["/usr/local/bin/custom_entrypoint.sh"]