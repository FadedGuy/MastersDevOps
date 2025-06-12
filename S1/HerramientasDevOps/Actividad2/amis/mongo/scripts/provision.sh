#!/bin/bash
set -e

# Actualizando paquetes
sudo apt-get update -y

# Instalando MongoDB
sudo apt-get install -y gnupg curl
curl -fsSL https://pgp.mongodb.com/server-6.0.asc | sudo gpg --dearmor -o /usr/share/keyrings/mongodb-server-6.0.gpg
echo "deb [ signed-by=/usr/share/keyrings/mongodb-server-6.0.gpg ] https://repo.mongodb.org/apt/ubuntu jammy/mongodb-org/6.0 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-6.0.list

sudo apt-get update -y
sudo apt-get install -y mongodb-org

# Configurando MongoDB para permitir acceso externo
sudo sed -i 's/^  bindIp: .*/  bindIp: 0.0.0.0/' /etc/mongod.conf

# Iniciando MongoDB para crear usuario admin (sin auth aún)
sudo systemctl enable mongod
sudo systemctl start mongod
sleep 5

# Creando usuario administrador
mongosh <<EOF
use admin
db.createUser({
  user: "admin",
  pwd: "adminpassword",
  roles: [ { role: "userAdminAnyDatabase", db: "admin" }, "readWriteAnyDatabase" ]
})
EOF

# Habilitando autenticación
echo -e "security:\n  authorization: enabled" | sudo tee -a /etc/mongod.conf >/dev/null

sudo systemctl restart mongod
