FROM php:8.2-fpm

# Add arguments for user and group IDs to match host user
ARG PUID=1000
ARG PGID=1000

# 1. Install system dependencies, including zsh
RUN apt-get update && apt-get install -y \
    git \
    curl \
    unzip \
    zip \
    zsh \
    libpq-dev \
    libxml2-dev \
    libonig-dev

# 2. Create a non-root user with matching host UID/GID to avoid permission issues
RUN groupadd -g ${PGID} dev && \
    useradd -u ${PUID} -g dev -ms /bin/zsh dev

# 3. Install required PHP extensions
RUN docker-php-ext-install \
    pdo \
    pdo_pgsql \
    mbstring \
    xml \
    bcmath

# 4. Install Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# 5. Add custom aliases
# Copy the alias file into the container, owned by the new user.
COPY --chown=dev:dev php/aliases.zsh /home/dev/aliases.zsh

# 6. Install Oh-My-Zsh and configure aliases
# We switch to the user to run the installer, then add the command to source the aliases file to .zshrc
USER dev
RUN sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" --unattended \
    && echo "\nsource ~/aliases.zsh" >> ~/.zshrc
USER root


# Set the working directory
WORKDIR /var/www/html
