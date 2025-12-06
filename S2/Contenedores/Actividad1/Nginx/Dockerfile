FROM nginx:latest

# Copiar WordPress desde la imagen PHP
COPY --from=fadedguy/my-wordpress:latest /usr/src/wordpress /var/www/wordpress

# Copiar configuración de Nginx
COPY nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 80
