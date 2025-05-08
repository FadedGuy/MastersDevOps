#!/bin/bash

# Actualizamos los paquetes
sudo apt-get update

# Instalamos nginx y curl
sudo apt-get install -y nginx curl

# Configuramos firewall para nginx
sudo ufw allow "Nginx HTTP"

# Descargamos y configuramos nodejs v18
curl -sL https://deb.nodesource.com/setup_18.x | sudo -E bash -
sudo apt install -y nodejs build-essential

# Instalamos PM2 para el manejo de procesos
sudo npm install pm2@latest -g
pm2 start ~/app/hello.js
pm2 startup systemd
sudo env PATH=$PATH:/usr/bin /usr/lib/node_modules/pm2/bin/pm2 startup systemd -u ubuntu --hp /home/ubuntu
sudo systemctl start pm2-ubuntu
systemctl status pm2-ubuntu

# Deshabilitamos el sitio por defecto
sudo rm /etc/nginx/sites-enabled/default

# ReverseProxy de Nginx para la aplicacion en el puerto 3000
sudo cp ~/scripts/helloApp /etc/nginx/sites-available/helloApp
sudo ln -s /etc/nginx/sites-available/helloApp /etc/nginx/sites-enabled/
sudo nginx -t
sudo systemctl restart nginx
