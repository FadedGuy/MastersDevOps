# Imagen base de Nginx
FROM nginx:latest

# Copiar la configuracion
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Exponemos el puerto 80
EXPOSE 80

# No es necesario un CMD ya que la imagen de nginx viene con un CMD que es heredado debido a que esta imagen no tiene CMD o ENTRYPOINT definido