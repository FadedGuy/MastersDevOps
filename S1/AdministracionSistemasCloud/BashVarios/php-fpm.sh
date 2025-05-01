#!/bin/bash
set -e
logger "Arrancando instalacion y configuracion de PHP-FPM"
USO="Uso : install.sh [opciones]
Ejemplo:
install.sh -s mysite.com
Opciones:
-s nombre del site en nginx
-a muestra esta ayuda
"

function ayuda() {
    echo "${USO}"
    if [[ ${1} ]]; then
        echo ${1}
    fi
}
# Gestionar las opciones
while getopts ":u:g:l:a" OPCION; do
    case ${OPCION} in
    s)
        NGINX_SITE=$OPTARG
        logger "Parametro NGINX_SITE establecido con '${NGINX_SITE}'"
        ;;
    a)
        ayuda
        exit 0
        ;;
    :)
        ayuda "Falta el parámetro para -$OPTARG"
        exit 1
        ;;
    \?)
        ayuda "La opción no existe : $OPTARG"
        exit 1
        ;;
    esac
done

if [ -z ${NGINX_SITE} ]; then
    NGINX_SITE="php.local"
fi

# Instalar PHP-FPM usando apt-get o yum dependiendo de la plataforma
if [[ -e /etc/redhat-release || -e /etc/system-release ]]; then
    # Solo se soporta la instalacion en la release 7 de RedHat y CentOS
    OS=$(rpm -q --whatprovides redhat-release | cut -d"-" -f1)
    RELEASE=$(rpm -q --whatprovides redhat-release | cut -d"-" -f3)
    if [[ "${OS}" != "centos" && "${OS}" != "redhat" ]]; then
        logger "La instalacion solo esta soportada en RedHat y CentOS"
        exit 2
    fi
    if [[ "${RELEASE}" != "7" ]]; then
        logger "La instalacion solo esta soportada en CentOS y RedHat release 7"
        exit 3
    fi
    # Configuracion de SElinux
    setenforce permissive
    # Preparacion de yum con los repositorios de nginx y php-fpm
    (
        cat <<NGINX_REPO
[nginx]
name=nginx repo
baseurl=http://nginx.org/packages/mainline/rhel/7/\$basearch/
gpgcheck=0
enabled=1
NGINX_REPO
    ) >/etc/yum.repos.d/nginx.repo
    yum install -y epel-release
    yum install -y http://rpms.remirepo.net/enterprise/remi-release-7.rpm
    yum install -y yum-utils
    yum-config-manager --enable remi-php72
    yum update -y
    # Instalacion y configuracion de nginx
    yum install -y nginx
    (
        cat <<NGINX_CONF
server {
listen 80;
root /var/www/html;
index index.php index.html index.htm;
server_name $NGINX_SITE;
location / {
try_files \$uri \$uri/ =404;
}
location ~ \.php$ {
fastcgi_pass unix:/var/run/php/php7.2-fpm.sock;
fastcgi_index index.php;
fastcgi_param SCRIPT_FILENAME \$document_root\$fastcgi_script_name;
include fastcgi_params;
}
}
NGINX_CONF
    ) >/etc/nginx/conf.d/$NGINX_SITE.conf
    rm /etc/nginx/conf.d/default.conf
    systemctl start nginx
    # Instalacion y configuracion de php-fom
    yum install -y php72 php72-php-fpm php72-php-gd \
        php72-php-json php72-php-mbstring php72-php-mysqlnd \
        php72-php-xml php72-php-xmlrpc php72-php-opcache
    mkdir /var/run/php
    chown nginx:nginx /var/run/php/
    sed -i "s/user =.*/user = nginx/g" /etc/opt/remi/php72/php-fpm.d/www.conf
    sed -i "s/group =.*/group = nginx/g" /etc/opt/remi/php72/php-fpm.d/www.conf
    sed -i "s/listen =.*/listen = \/var\/run\/php\/php7.2-fpm.sock/g" /etc/opt/remi/php72/php-fpm.d/www.conf
    sed -i "s/.*listen.owner =.*/listen.owner = nginx/g" /etc/opt/remi/php72/php-fpm.d/www.conf
    sed -i "s/.*listen.group =.*/listen.group = nginx/g" /etc/opt/remi/php72/php-fpm.d/www.conf
    sed -i "s/.*listen.mode =.*/listen.mode = 0660/g" /etc/opt/remi/php72/php-fpm.d/www.conf
    systemctl enable php72-php-fpm.service
    systemctl start php72-php-fpm.service
    # Limpieza de archivos temporales tras la instalacion
    yum clean all
else
    # configuracion de respositorios
    export DEBIAN_FRONTEND=noninteractive
    apt-get install software-properties-common
    add-apt-repository -y ppa:ondrej/nginx-mainline
    apt-get install -y nginx php7.2 php7.2-fpm
    # Crear el archivo del site de nginx
    (
        cat <<NGINX_CONF
server {
listen 80;
root /var/www/html;
index index.php index.html index.htm;
server_name $NGINX_SITE;
location / {
try_files \$uri \$uri/ =404;
}
location ~ \.php$ {
include snippets/fastcgi-php.conf;
fastcgi_pass unix:/var/run/php/php7.2-fpm.sock;
}
}
NGINX_CONF
    ) >/etc/nginx/sites-available/$NGINX_SITE
    rm /etc/nginx/sites-enabled/default
    sudo ln -s /etc/nginx/sites-available/$NGINX_SITE /etc/nginx/sites-enabled/$NGINX_SITE
    systemctl restart nginx
# La configuracion por defecto de PHP-FPM es suficiente
fi

# Creacion de un fichero de prueba en la raiz
# Sera accesible tras la instalacion en http://<ip_del_servidor>/info.php
mkdir -p /var/www/html
echo "<?php phpinfo(); ?>" >/var/www/html/info.php
id -u nginx && chown -R nginx:nginx /var/www || chown -R www-data:www-data /var/www
chmod -R 755 /var/www
logger "Instalacion completada con exito; visite http://<ip>/info.php para comprobarlo"
exit 0
