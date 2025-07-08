#!/bin/bash
# =================== ELK Stack + APM Provisioning Script ===================
#  SCRIPT COMPLETO PARA MONITORIZACIÓN FINTECH

set -e  # Exit on any error

echo " Starting ELK Stack + APM provisioning..."

#  Actualizar sistema
echo " Updating system packages..."
sudo apt-get update -y
sudo apt-get upgrade -y

#  Instalar dependencias
echo " Installing dependencies..."
sudo apt-get install -y nginx openssl apt-transport-https ca-certificates curl wget gpg software-properties-common

#  Generar certificados SSL
echo " Generating SSL certificates..."
sudo mkdir -p /etc/nginx/ssl
sudo openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
  -subj "/CN=elk.fintech.local/O=FinTech Solutions/C=US" \
  -keyout /etc/nginx/ssl/key.pem \
  -out /etc/nginx/ssl/cert.pem

#  Configurar firewall
echo " Configuring firewall..."
sudo ufw allow ssh
sudo ufw allow "Nginx HTTP"
sudo ufw allow "Nginx HTTPS"
sudo ufw allow 9200/tcp  # Elasticsearch
sudo ufw allow 5601/tcp  # Kibana
sudo ufw allow 5044/tcp  # Logstash
sudo ufw allow 8200/tcp  # APM Server
sudo ufw --force enable

#  Agregar clave GPG de Elastic
echo " Adding Elastic GPG key..."
wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo gpg --dearmor -o /usr/share/keyrings/elasticsearch-keyring.gpg

echo "deb [signed-by=/usr/share/keyrings/elasticsearch-keyring.gpg] https://artifacts.elastic.co/packages/8.x/apt stable main" | sudo tee /etc/apt/sources.list.d/elastic-8.x.list

#  Actualizar paquetes
sudo apt-get update

#  INSTALAR ELASTICSEARCH
echo " Installing Elasticsearch..."
sudo apt-get install -y elasticsearch

#  Copiar configuración de Elasticsearch
sudo cp /home/ubuntu/elasticsearch/elasticsearch.yml /etc/elasticsearch/elasticsearch.yml

#  Configurar permisos
sudo chown root:elasticsearch /etc/elasticsearch/elasticsearch.yml
sudo chmod 660 /etc/elasticsearch/elasticsearch.yml

#  Iniciar Elasticsearch
sudo systemctl daemon-reload
sudo systemctl enable elasticsearch.service
sudo systemctl start elasticsearch.service

# ⏳ Esperar a que Elasticsearch inicie
echo "⏳ Waiting for Elasticsearch to start..."
sleep 30

#  Configurar password para elastic (si está habilitado x-pack)
if sudo grep -q "xpack.security.enabled: true" /etc/elasticsearch/elasticsearch.yml; then
    echo " Setting up Elasticsearch security..."
    sudo /usr/share/elasticsearch/bin/elasticsearch-setup-passwords auto -b > /tmp/elastic-passwords.txt
    sudo chown ubuntu:ubuntu /tmp/elastic-passwords.txt
    echo "📝 Passwords saved to /tmp/elastic-passwords.txt"
fi

#  INSTALAR KIBANA
echo " Installing Kibana..."
sudo apt-get install -y kibana

#  Copiar configuración de Kibana
sudo cp /home/ubuntu/kibana/kibana.yml /etc/kibana/kibana.yml
sudo chown root:kibana /etc/kibana/kibana.yml
sudo chmod 660 /etc/kibana/kibana.yml

#  Iniciar Kibana
sudo systemctl daemon-reload
sudo systemctl enable kibana.service
sudo systemctl start kibana.service

#  INSTALAR LOGSTASH
echo " Installing Logstash..."
sudo apt-get install -y logstash

#  Copiar configuraciones de Logstash
sudo cp /home/ubuntu/logstash/logstash.yml /etc/logstash/logstash.yml
sudo cp /home/ubuntu/logstash/pipelines.yml /etc/logstash/pipelines.yml

#  Crear directorio de configuración
sudo mkdir -p /etc/logstash/conf.d

#  Copiar pipelines de Logstash
sudo cp -r /home/ubuntu/logstash/pipelines/* /etc/logstash/conf.d/

#  Configurar permisos de Logstash
sudo chown -R root:logstash /etc/logstash/
sudo chmod -R 660 /etc/logstash/*.yml
sudo chmod -R 644 /etc/logstash/conf.d/*

#  Iniciar Logstash
sudo systemctl daemon-reload
sudo systemctl enable logstash.service
sudo systemctl start logstash.service

#  INSTALAR APM SERVER
echo " Installing APM Server..."
sudo apt-get install -y apm-server

#  Copiar configuración de APM
sudo cp /home/ubuntu/apm-server/apm-server.yml /etc/apm-server/apm-server.yml
sudo chown root:apm-server /etc/apm-server/apm-server.yml
sudo chmod 600 /etc/apm-server/apm-server.yml

#  Iniciar APM Server
sudo systemctl daemon-reload
sudo systemctl enable apm-server.service
sudo systemctl start apm-server.service

#  CONFIGURAR NGINX REVERSE PROXY
echo " Configuring Nginx reverse proxy..."
sudo rm -f /etc/nginx/sites-enabled/default

sudo tee /etc/nginx/sites-available/elk-stack << 'EOF'
# =================== ELK Stack Nginx Configuration ===================
# Configuración optimizada para monitorización FinTech

# Upstream definitions
upstream elasticsearch {
    server 127.0.0.1:9200;
    keepalive 15;
}

upstream kibana {
    server 127.0.0.1:5601;
    keepalive 15;
}

upstream apm_server {
    server 127.0.0.1:8200;
    keepalive 15;
}

# HTTP Server
server {
    listen 80;
    server_name _;
    
    # Security headers
    add_header X-Frame-Options "SAMEORIGIN" always;
    add_header X-Content-Type-Options "nosniff" always;
    add_header X-XSS-Protection "1; mode=block" always;
    
    # Logging
    access_log /var/log/nginx/elk-access.log;
    error_log /var/log/nginx/elk-error.log;
    
    # Health check
    location /health {
        return 200 'ELK Stack OK';
        add_header Content-Type text/plain;
        access_log off;
    }
    
    # Elasticsearch proxy
    location /elasticsearch/ {
        rewrite ^/elasticsearch/(.*) /$1 break;
        proxy_pass http://elasticsearch;
        proxy_http_version 1.1;
        proxy_set_header Connection "";
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        
        # Timeouts
        proxy_connect_timeout 60s;
        proxy_send_timeout 60s;
        proxy_read_timeout 60s;
        
        # Security - restrict to internal IPs
        allow 127.0.0.1;
        allow 10.0.0.0/8;
        allow 172.16.0.0/12;
        allow 192.168.0.0/16;
        deny all;
    }
    
    # Kibana proxy
    location /kibana/ {
        rewrite ^/kibana/(.*) /$1 break;
        proxy_pass http://kibana;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        proxy_cache_bypass $http_upgrade;
        
        # Timeouts for Kibana
        proxy_connect_timeout 60s;
        proxy_send_timeout 60s;
        proxy_read_timeout 60s;
        
        # Buffer settings
        proxy_buffering off;
    }
    
    # APM Server proxy
    location /apm/ {
        rewrite ^/apm/(.*) /$1 break;
        proxy_pass http://apm_server;
        proxy_http_version 1.1;
        proxy_set_header Connection "";
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        
        # Allow larger payloads for APM
        client_max_body_size 10M;
    }
    
    # Redirect root to Kibana
    location = / {
        return 301 /kibana/;
    }
}

# HTTPS Server
server {
    listen 443 ssl http2;
    server_name _;
    
    # SSL Configuration
    ssl_certificate /etc/nginx/ssl/cert.pem;
    ssl_certificate_key /etc/nginx/ssl/key.pem;
    ssl_protocols TLSv1.2 TLSv1.3;
    ssl_ciphers ECDHE-RSA-AES128-GCM-SHA256:ECDHE-RSA-AES256-GCM-SHA384:ECDHE-RSA-AES128-SHA256:ECDHE-RSA-AES256-SHA384;
    ssl_prefer_server_ciphers off;
    ssl_session_cache shared:SSL:10m;
    ssl_session_timeout 1d;
    
    # Security headers
    add_header Strict-Transport-Security "max-age=63072000" always;
    add_header X-Frame-Options "SAMEORIGIN" always;
    add_header X-Content-Type-Options "nosniff" always;
    add_header X-XSS-Protection "1; mode=block" always;
    
    # Logging
    access_log /var/log/nginx/elk-ssl-access.log;
    error_log /var/log/nginx/elk-ssl-error.log;
    
    # Same locations as HTTP but with SSL
    location /health {
        return 200 'ELK Stack OK (SSL)';
        add_header Content-Type text/plain;
        access_log off;
    }
    
    location /elasticsearch/ {
        rewrite ^/elasticsearch/(.*) /$1 break;
        proxy_pass http://elasticsearch;
        proxy_http_version 1.1;
        proxy_set_header Connection "";
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        
        allow 127.0.0.1;
        allow 10.0.0.0/8;
        allow 172.16.0.0/12;
        allow 192.168.0.0/16;
        deny all;
    }
    
    location /kibana/ {
        rewrite ^/kibana/(.*) /$1 break;
        proxy_pass http://kibana;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        proxy_cache_bypass $http_upgrade;
        proxy_buffering off;
    }
    
    location /apm/ {
        rewrite ^/apm/(.*) /$1 break;
        proxy_pass http://apm_server;
        proxy_http_version 1.1;
        proxy_set_header Connection "";
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        client_max_body_size 10M;
    }
    
    location = / {
        return 301 /kibana/;
    }
}
EOF

sudo ln -sf /etc/nginx/sites-available/elk-stack /etc/nginx/sites-enabled/
sudo nginx -t
sudo systemctl restart nginx
sudo systemctl enable nginx

# ⏳ Esperar a que todos los servicios inicien
echo "⏳ Waiting for all services to start..."
sleep 60

#  TESTS DE CONECTIVIDAD
echo " Testing connectivity..."

echo "Testing Elasticsearch..."
curl -f http://localhost:9200/_cluster/health || echo " Elasticsearch not responding"

echo "Testing Kibana..."
curl -f http://localhost:5601/api/status || echo " Kibana not responding"

echo "Testing APM Server..."
curl -f http://localhost:8200/ || echo " APM Server not responding"

echo "Testing Nginx..."
curl -f http://localhost/health || echo " Nginx not responding"

#  CONFIGURAR DASHBOARDS AUTOMÁTICOS
echo " Setting up automatic dashboards..."

# Setup Kibana index patterns y dashboards
if curl -f http://localhost:9200/_cluster/health; then
    echo "Setting up Kibana dashboards..."
    
    # Esperar a que Kibana esté completamente iniciado
    sleep 30
    
    # Setup dashboards para Filebeat
    sudo filebeat setup --dashboards -E output.elasticsearch.hosts=["localhost:9200"] -E setup.kibana.host=localhost:5601 || echo "Filebeat dashboards setup failed"
    
    # Setup dashboards para Metricbeat
    sudo metricbeat setup --dashboards -E output.elasticsearch.hosts=["localhost:9200"] -E setup.kibana.host=localhost:5601 || echo "Metricbeat dashboards setup failed"
    
    # Setup dashboards para APM
    sudo apm-server setup --dashboards -E output.elasticsearch.hosts=["localhost:9200"] -E setup.kibana.host=localhost:5601 || echo "APM dashboards setup failed"
fi

#  Crear script de monitoreo
sudo tee /usr/local/bin/elk-health-check.sh << 'EOF'
#!/bin/bash
# Health check script for ELK Stack

echo "=== ELK Stack Health Check ==="
echo "Timestamp: $(date)"

echo "1. Elasticsearch Cluster Health:"
curl -s http://localhost:9200/_cluster/health | jq '.status' 2>/dev/null || echo "Elasticsearch unavailable"

echo "2. Elasticsearch Indices:"
curl -s http://localhost:9200/_cat/indices?v | head -5

echo "3. Kibana Status:"
curl -s http://localhost:5601/api/status | jq '.status.overall.state' 2>/dev/null || echo "Kibana unavailable"

echo "4. APM Server Status:"
curl -s http://localhost:8200/ | head -c 50 || echo "APM Server unavailable"

echo "5. System Resources:"
echo "Memory: $(free -h | grep '^Mem:' | awk '{print $3 "/" $2}')"
echo "CPU: $(top -bn1 | grep "Cpu(s)" | sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | awk '{print 100 - $1"%"}')"

echo "6. Disk Space:"
df -h / | tail -1 | awk '{print $5 " used of " $2}'

echo "7. Service Status:"
systemctl is-active elasticsearch || echo "Elasticsearch service inactive"
systemctl is-active kibana || echo "Kibana service inactive"
systemctl is-active logstash || echo "Logstash service inactive"
systemctl is-active apm-server || echo "APM Server service inactive"
EOF

sudo chmod +x /usr/local/bin/elk-health-check.sh

#  Configurar cron para health checks
echo "*/5 * * * * root /usr/local/bin/elk-health-check.sh >> /var/log/elk-health-check.log 2>&1" | sudo tee -a /etc/crontab

#  VERIFICAR ESTADO FINAL
echo " Final status check..."
echo "=== Service Status ==="
sudo systemctl status elasticsearch --no-pager
sudo systemctl status kibana --no-pager
sudo systemctl status logstash --no-pager
sudo systemctl status apm-server --no-pager
sudo systemctl status nginx --no-pager

echo " ELK Stack + APM provisioning completed successfully!"
echo ""
echo "=== ACCESS INFORMATION ==="
echo " Elasticsearch: http://$(curl -s ifconfig.me):9200"
echo " Kibana: http://$(curl -s ifconfig.me)/kibana/"
echo " APM Server: http://$(curl -s ifconfig.me):8200"
echo " HTTPS Access: https://$(curl -s ifconfig.me)/"
echo ""
echo "=== IMPORTANT FILES ==="
echo " Health check: /usr/local/bin/elk-health-check.sh"
echo "📝 Logs: /var/log/elasticsearch/, /var/log/kibana/, /var/log/logstash/"
echo "⚙ Configs: /etc/elasticsearch/, /etc/kibana/, /etc/logstash/, /etc/apm-server/"

if [ -f /tmp/elastic-passwords.txt ]; then
    echo " Elasticsearch passwords: /tmp/elastic-passwords.txt"
fi
