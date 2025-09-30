#!/bin/bash
set -e

# Asignar valores por defecto si no existen
# Base de datos
DB_NAME=${DB_NAME:-wordpress}
DB_USER=${DB_USER:-wpuser}
DB_PASSWORD=${DB_PASSWORD:-wppassword}
DB_HOST=${DB_HOST:-wp-db}

# Configuracion de WordPress
WP_URL=${WP_URL:-http://localhost:8080}
WP_TITLE=${WP_TITLE:-"Mi WordPress"}
WP_ADMIN_USER=${WP_ADMIN_USER:-admin}
WP_ADMIN_PASSWORD=${WP_ADMIN_PASSWORD:-adminpassword}
WP_ADMIN_EMAIL=${WP_ADMIN_EMAIL:-kevin.aceves@hotmail.com}

# Copiar wp-config.php si no existe
if [ ! -f /var/www/wordpress/wp-config.php ]; then
    cp /var/www/wordpress/wp-config-sample.php /var/www/wordpress/wp-config.php
    sed -i "s/database_name_here/$DB_NAME/" /var/www/wordpress/wp-config.php
    sed -i "s/username_here/$DB_USER/" /var/www/wordpress/wp-config.php
    sed -i "s/password_here/$DB_PASSWORD/" /var/www/wordpress/wp-config.php
    sed -i "s/localhost/$DB_HOST/" /var/www/wordpress/wp-config.php

    # Instalar WordPress usando WP-CLI
    wp core install \
        --url="$WP_URL" \
        --title="$WP_TITLE" \
        --admin_user="$WP_ADMIN_USER" \
        --admin_password="$WP_ADMIN_PASSWORD" \
        --admin_email="$WP_ADMIN_EMAIL" \
        --path="/var/www/wordpress"
fi

# Arrancar PHP-FPM
php-fpm
