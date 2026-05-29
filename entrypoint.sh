#!/bin/bash

# Add OpenCode binary to PATH
export PATH="/home/opencodeuser/.opencode/bin:$PATH"

echo "Starting custom entrypoint..."

# Ensure state directory exists for OpenCode
if [ ! -d /home/opencodeuser/.local/state ]; then
    echo "Creating .local/state directory..."
    mkdir -p /home/opencodeuser/.local/state
fi

# Ensure OpenCode config exists with Ollama provider (in case volume is empty)
if [ ! -f /home/opencodeuser/.config/opencode/opencode.json ]; then
    echo "Creating default opencode.json with Ollama provider..."
    mkdir -p /home/opencodeuser/.config/opencode
    cat > /home/opencodeuser/.config/opencode/opencode.json << 'EOF'
{
  "$schema": "https://opencode.ai/config.json",
  "provider": {
    "ollama": {
      "npm": "@ai-sdk/openai-compatible",
      "options": {
        "baseURL": "http://localhost:11434/v1"
      },
      "models": {}
    }
  }
}
EOF
    chown -R opencodeuser:opencodeuser /home/opencodeuser/.config/opencode
fi

# Ensure auth placeholder exists for Ollama
if [ ! -f /home/opencodeuser/.local/share/opencode/auth.json ]; then
    echo "Creating auth placeholder for Ollama..."
    mkdir -p /home/opencodeuser/.local/share/opencode
    echo '{"ollama":{"type":"api","key":"ollama"}}' > /home/opencodeuser/.local/share/opencode/auth.json
    chown -R opencodeuser:opencodeuser /home/opencodeuser/.local/share/opencode
fi

# Start Ollama in the background
echo "Starting Ollama server in background..."
/usr/bin/ollama serve &
OLLAMA_PID=$!
echo "Ollama server started with PID: $OLLAMA_PID"

# Give Ollama some time to initialize
echo "Waiting 10 seconds for Ollama to initialize..."
sleep 10

# Check if Ollama is running
if ps -p $OLLAMA_PID > /dev/null
then
   echo "Ollama server is running."
else
   echo "Ollama server is NOT running. Exiting."
   exit 1
fi

# Keep the container running
echo "Keeping container alive with tail -f /dev/null"
tail -f /dev/null
