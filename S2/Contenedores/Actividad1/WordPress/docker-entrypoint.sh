#!/bin/bash
set -e

WP_PATH="/var/www/wordpress"

# Si el directorio está vacío, copiar WordPress inicial
if [ ! -f "$WP_PATH/wp-config-sample.php" ]; then
    echo "WordPress directory empty. Copying initial WordPress files..."
    cp -R /usr/src/wordpress/* "$WP_PATH"
fi

# Variables de entorno por defecto
DB_NAME=${DB_NAME:-wordpress}
DB_USER=${DB_USER:-wpuser}
DB_PASSWORD=${DB_PASSWORD:-wppassword}
DB_HOST=${DB_HOST:-wp-db}

WP_URL=${WP_URL:-http://localhost:8080}
WP_TITLE=${WP_TITLE:-"Mi WordPress"}
WP_ADMIN_USER=${WP_ADMIN_USER:-admin}
WP_ADMIN_PASSWORD=${WP_ADMIN_PASSWORD:-adminpassword}
WP_ADMIN_EMAIL=${WP_ADMIN_EMAIL:-admin@example.com}

# Crear wp-config.php si no existe
if [ ! -f "$WP_PATH/wp-config.php" ]; then
    cp "$WP_PATH/wp-config-sample.php" "$WP_PATH/wp-config.php"

    sed -i "s/database_name_here/$DB_NAME/" "$WP_PATH/wp-config.php"
    sed -i "s/username_here/$DB_USER/" "$WP_PATH/wp-config.php"
    sed -i "s/password_here/$DB_PASSWORD/" "$WP_PATH/wp-config.php"
    sed -i "s/localhost/$DB_HOST/" "$WP_PATH/wp-config.php"

    # Instalar WordPress
    wp core install \
        --url="$WP_URL" \
        --title="$WP_TITLE" \
        --admin_user="$WP_ADMIN_USER" \
        --admin_password="$WP_ADMIN_PASSWORD" \
        --admin_email="$WP_ADMIN_EMAIL" \
        --path="$WP_PATH"
fi

# Iniciar PHP-FPM
exec php-fpm
