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

# Crear directorio para WordPress
RUN mkdir -p /var/www && chown www-data:www-data /var/www

# Descargar WordPress
RUN curl -sSL https://wordpress.org/latest.tar.gz | tar -xz -C /var/www && \
    chown -R www-data:www-data /var/www/wordpress

# Instalar WP-CLI
RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
    && chmod +x wp-cli.phar \
    && mv wp-cli.phar /usr/local/bin/wp

# Copiar entrypoint y hacerlo ejecutable
COPY docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

# Establecer el usuario del contenedor a www-data (en lugar de root)
USER www-data

# Establecer directorio de trabajo
WORKDIR /var/www/wordpress

# Exponer el puerto 9000
EXPOSE 9000

# Indicar que el punto de entrada es el script
ENTRYPOINT ["docker-entrypoint.sh"]
