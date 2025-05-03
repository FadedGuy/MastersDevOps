#!/bin/bash
set -e

# Variables
APP_VERSION="{{.Vars.app_version}}"
LOG_FILE="/tmp/setup_app.log"

# Redireccionar la salida a un archivo de registro
exec &> >(tee -a "$LOG_FILE")

echo "Iniciando la configuración de la aplicación - Version: $APP_VERSION"

# Actualizar paquetes
echo "Actualizando paquetes..."
sudo apt-get update -y

# Instalar dependencias
echo "Instalando dependencias..."
sudo apt-get install -y git python3 python3-pip

# Clonar el repositorio de la aplicación (ejemplo)
echo "Clonando el repositorio de la aplicación..."
git clone https://github.com/ejemplo/mi-app-web.git /var/www/html

# Instalar dependencias de Python (ejemplo)
echo "Instalando dependencias de Python..."
pip3 install -r /var/www/html/requirements.txt

# Configurar Nginx (ejemplo)
echo "Configurando Nginx..."
sudo rm /etc/nginx/sites-available/default
sudo ln -s /var/www/html/nginx.conf /etc/nginx/sites-available/mi-app

# Crear enlace simbólico para habilitar el sitio
sudo ln -s /etc/nginx/sites-available/mi-app /etc/nginx/sites-enabled/

# Configurar el archivo index.html
echo "Configurando el archivo index.html..."
sudo cp /tmp/index.html /var/www/html/index.html

# Reiniciar Nginx
echo "Reiniciando Nginx..."
sudo systemctl restart nginx

echo "Configuración de la aplicación finalizada"