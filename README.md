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
| `build.sh` | `build` | Construye todos los contenedores desde cero, levanta los servicios y entra al contenedor PHP. |
| `up.sh` | `up` | Levanta los servicios (sin rebuild) y entra al contenedor PHP. |
| `opencode.sh` | `opencode` | Abre OpenCode dentro del contenedor. |
| `ollama.sh` | `ollama` | Ejecuta comandos de Ollama dentro del contenedor. |

### build.sh

Construcción completa y entrada a PHP:

```bash
./build.sh
# o con alias
build
```

### up.sh

Versión ligera: solo levanta servicios y entra a PHP (sin reconstruir):

```bash
./up.sh
# o con alias
up
```

### opencode.sh

Abre OpenCode dentro del contenedor:

```bash
./opencode.sh
# o con alias
opencode
```

### ollama.sh

Gestiona Ollama dentro del contenedor:

```bash
./ollama.sh pull qwen2.5-coder:7b
./ollama.sh list
# o con alias
ollama pull qwen2.5-coder:7b
ollama list
```

## Aliases recomendados

Añade estas líneas a tu `~/.zshrc` o `~/.bashrc` para usar los scripts desde cualquier carpeta:

```bash
alias build='/Users/usuario/proyectos/docker/build.sh'
alias up='/Users/usuario/proyectos/docker/up.sh'
alias ollama='/Users/usuario/proyectos/docker/ollama.sh'
alias opencode='/Users/usuario/proyectos/docker/opencode.sh'
```

Después de añadirlos, recarga la configuración:

```bash
source ~/.zshrc
```

## Estructura del Proyecto

```
├── build.sh              # Build completo + exec php
├── up.sh                 # up -d + exec php
├── ollama.sh             # Wrapper de Ollama
├── opencode.sh           # Wrapper de OpenCode
├── docker-compose.yml    # Configuración de servicios
├── Dockerfile            # Imagen de OpenCode + Ollama
├── php/
│   └── Dockerfile        # Imagen de PHP
├── nginx.conf            # Configuración de Nginx
├── entrypoint.sh         # Entrypoint del contenedor opencode
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