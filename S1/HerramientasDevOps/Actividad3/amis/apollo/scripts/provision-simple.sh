#!/bin/bash
# =================== Simple Apollo Provisioning for Testing ===================

echo " Starting simple Apollo Server provisioning..."

#  Actualizar sistema (más tolerante a errores)
echo " Updating system packages..."
sudo apt-get clean
sudo rm -rf /var/lib/apt/lists/*
sudo apt-get update --fix-missing || true
sudo apt-get update -y || true

#  Instalar dependencias básicas
echo " Installing basic dependencies..."
sudo apt-get install -y curl wget gpg apt-transport-https ca-certificates || true

# 🟢 Instalar Node.js 18
echo "🟢 Installing Node.js 18..."
curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash - || true
sudo apt-get install -y nodejs build-essential || true

#  Verificar instalación de Node.js
node --version || echo "Node.js installation may have issues"
npm --version || echo "NPM installation may have issues"

#  Crear directorios necesarios
echo " Creating necessary directories..."
sudo mkdir -p /home/ubuntu/app/logs
sudo chown -R ubuntu:ubuntu /home/ubuntu/app

echo " Basic Apollo Server setup completed (simplified for testing)!"
