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

# 3. Install nvm, Node.js, and Yarn
ENV NVM_DIR /home/dev/.nvm
ENV NODE_VERSION 24.12.0
ENV PATH $NVM_DIR/versions/node/v$NODE_VERSION/bin:$PATH

RUN mkdir -p $NVM_DIR && \
    chown -R dev:dev $NVM_DIR && \
    su - dev -c "curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash" && \
    su - dev -c ". $NVM_DIR/nvm.sh && nvm install $NODE_VERSION" && \
    su - dev -c ". $NVM_DIR/nvm.sh && npm install -g yarn"

# 4. Add nvm to .zshrc
RUN echo 'export NVM_DIR="$HOME/.nvm"' >> /home/dev/.zshrc && \
    echo '[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm' >> /home/dev/.zshrc && \
    echo '[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion' >> /home/dev/.zshrc

# 5. Install required PHP extensions
RUN docker-php-ext-install \
    pdo \
    pdo_pgsql \
    mbstring \
    xml \
    bcmath \
    pcntl

# Install redis
RUN pecl install redis && docker-php-ext-enable redis


# 6. Install Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Install Laravel Installer globally
USER dev
RUN composer global require laravel/installer
USER root


# 7. Add custom aliases
# Copy the alias file into the container, owned by the new user.
COPY --chown=dev:dev php/aliases.zsh /home/dev/aliases.zsh

# 8. Install Oh-My-Zsh and configure aliases
# We switch to the user to run the installer, then add the command to source the aliases file to .zshrc
USER dev
RUN sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" --unattended \
    && echo "\nsource ~/aliases.zsh" >> ~/.zshrc
USER root


# Set the working directory
WORKDIR /var/www/html


# Expose port 9000 and start php-fpm server
EXPOSE 9000
CMD ["php-fpm"]
