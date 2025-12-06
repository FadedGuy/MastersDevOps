# Imagen base de PHP con FPM
FROM php:8.2-fpm

# Instalar paquetes requeridos
RUN apt-get update && apt-get install -y \
    default-mysql-client \
    libzip-dev \
    libonig-dev \
    libxml2-dev \
    curl \
    tar \
    unzip \
    && docker-php-ext-install mysqli pdo pdo_mysql zip \
    && rm -rf /var/lib/apt/lists/*

# Crear directorios base
RUN mkdir -p /usr/src/wordpress && \
    mkdir -p /var/www && \
    chown -R www-data:www-data /var/www /usr/src/wordpress

# Descargar WordPress en /usr/src/wordpress
RUN curl -sSL https://wordpress.org/latest.tar.gz \
    | tar -xz -C /usr/src \
    && chown -R www-data:www-data /usr/src/wordpress

# Instalar WP-CLI
RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
    && chmod +x wp-cli.phar \
    && mv wp-cli.phar /usr/local/bin/wp

# Copiar entrypoint
COPY docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

# WordPress no debe correr como root
USER www-data

# WordPress path final
WORKDIR /var/www/wordpress

# Exponer PHP-FPM
EXPOSE 9000

ENTRYPOINT ["docker-entrypoint.sh"]
