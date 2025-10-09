# Docker Project

This is a Docker-based development environment for a PHP application with Nginx and PostgreSQL.

## Prerequisites

*   Docker
*   Docker Compose

## Getting Started

1.  **Clone the repository or download the files.**

2.  **Create a `.env` file** from the `.env.example` file and update the environment variables for your PostgreSQL database:

    ```bash
    cp .env.example .env
    ```

3.  **Place your PHP application code** in the `../php` directory (relative to this `docker-compose.yml` file).

4.  **Build and start the containers:**

    ```bash
    docker-compose up -d --build
    ```

5.  **Access your application** at [http://localhost](http://localhost).

## Services

*   **`nginx`**: The web server. It serves your application on port 80.
*   **`php`**: The PHP-FPM service. It runs your PHP code.
*   **`db`**: The PostgreSQL database service. It exposes port 5432.

## Stopping the environment

To stop the containers, run:

```bash
docker-compose down
```
