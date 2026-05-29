#!/bin/bash

PROJECT_DIR="/Users/usuario/proyectos/docker"

cd "$PROJECT_DIR" || exit

echo "🔨 Construyendo todos los contenedores..."
docker compose --profile app build

echo "🚀 Levantando los servicios..."
docker compose --profile app up -d

echo "💻 Entrando al contenedor PHP..."
docker compose --profile app exec -it php zsh
