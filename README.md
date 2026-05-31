# Proyecto Docker Dev Environment (OpenCode + Ollama + PHP)

Este proyecto configura un entorno de desarrollo Docker que incluye:
- **PHP** (con Nginx, PostgreSQL, Redis)
- **Ollama** (para correr modelos de lenguaje locales)
- **OpenCode** (un agente de programación AI de código abierto)

Ollama y OpenCode están combinados en un único servicio para simplificar la gestión.

## Requisitos

- Docker
- Docker Compose
- (Opcional) NVIDIA Container Toolkit para soporte de GPU

## Cómo empezar

1. **Crear un archivo `.env`** a partir del ejemplo y ajustar los valores:

   ```bash
   cp .env.example .env
   ```

2. **Usar los scripts incluidos** (ver sección [Scripts incluidos](#scripts-incluidos)).

## Scripts incluidos

| Script | Alias | Descripción |
|--------|-------|-------------|
| `run` | `run` | Menú interactivo con opciones up (defecto) y build. |
| `opencode/up` | `up` | Levanta los servicios (sin rebuild) y entra al contenedor PHP. |
| `opencode/build` | `build` | Construye todos los contenedores desde cero, levanta los servicios y entra al contenedor PHP. |
| `opencode-cli` | `opencode` | Abre OpenCode dentro del contenedor. |
| `ollama` | `ollama` | Ejecuta comandos de Ollama dentro del contenedor. |

### opencode/build

Construcción completa y entrada a PHP:

```bash
./opencode/build
# o con alias
build
```

### opencode/up

Versión ligera: solo levanta servicios y entra a PHP (sin reconstruir):

```bash
./opencode/up
# o con alias
up
```

### opencode-cli

Abre OpenCode dentro del contenedor:

```bash
./opencode-cli
# o con alias
opencode
```

### ollama

Gestiona Ollama dentro del contenedor:

```bash
./ollama pull qwen2.5-coder:7b
./ollama list
# o con alias
ollama pull qwen2.5-coder:7b
ollama list
```

## Aliases recomendados

Añade estas líneas a tu `~/.zshrc` o `~/.bashrc` para usar los scripts desde cualquier carpeta:

```bash
alias build='/Users/usuario/proyectos/docker/opencode/build'
alias up='/Users/usuario/proyectos/docker/opencode/up'
alias ollama='/Users/usuario/proyectos/docker/ollama'
alias opencode='/Users/usuario/proyectos/docker/opencode-cli'
alias run='/Users/usuario/proyectos/docker/run'
```

Después de añadirlos, recarga la configuración:

```bash
source ~/.zshrc
```

## Estructura del Proyecto

```
├── run                   # Menú interactivo (up por defecto)
├── opencode-cli           # Wrapper de OpenCode (CLI)
├── ollama                 # Wrapper de Ollama
├── opencode/
│   ├── Dockerfile        # Imagen de OpenCode + Ollama
│   ├── entrypoint.sh     # Entrypoint del contenedor opencode
│   ├── opencode.json     # Configuración de OpenCode
│   ├── up                # up -d + exec php
│   └── build             # Build completo + exec php
├── nginx/
│   └── nginx.conf        # Configuración de Nginx
├── php/
│   └── Dockerfile        # Imagen de PHP
├── docker-compose.yml    # Configuración de servicios
├── .env.example          # Variables de entorno de ejemplo
└── README.md
```

## Notas

- **Persistencia:** Los modelos descargados se guardan en el volumen `ollama_data` y las configuraciones de OpenCode en `opencode_config`.
- **GPU:** Si tienes una tarjeta NVIDIA, recuerda descomentar la sección `deploy` en `docker-compose.yml` para un mejor rendimiento.
- **Configuración de OpenCode:** La primera vez que ejecutes `opencode`, te preguntará qué modelo usar. Asegúrate de que apunte a `http://localhost:11434` (ya que Ollama corre en el mismo contenedor).

## Detener el entorno

```bash
docker compose down -v --remove-orphans
```

## Comandos manuales (sin scripts)

Si prefieres no usar los scripts, estos son los comandos equivalentes:

```bash
# Construir todo y entrar a PHP
docker compose --profile app build
docker compose --profile app up -d
docker compose --profile app exec -it php zsh

# Solo levantar y entrar a PHP
docker compose --profile app up -d
docker compose --profile app exec -it php zsh

# Ejecutar Ollama
docker compose --profile app exec opencode ollama <comando>

# Ejecutar OpenCode
docker compose --profile app exec opencode /home/opencodeuser/.opencode/bin/opencode
```