#!/bin/bash

PROJECT_DIR="/Users/usuario/proyectos/docker"
CONTAINER_NAME="opencode"

cd "$PROJECT_DIR" || exit

# Check if the opencode-client container is running
if [ "$(docker ps -q -f name=opencode-client)" == "" ]; then
    echo "📦 El servicio 'opencode' no está corriendo. Levantando el servicio..."
    docker compose --profile app up -d
    sleep 10 # Wait for entrypoint to initialize Ollama
fi

# Execute opencode command inside the opencode-client container
docker compose -f "$PROJECT_DIR/docker-compose.yml" --profile app exec -it opencode /home/opencodeuser/.opencode/bin/opencode "$@"