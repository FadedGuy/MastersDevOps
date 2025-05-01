#!/bin/bash

AYUDA="Las variables APP_ENTRY_POINT, APP_FOLDER y CLONE_URL deben
tener valores validos.
Ejemplo:
export APP_ENTRY_POINT=bin/www
export APP_FOLDER=/opt/app
export CLONE_URL=https://github.com/plesk/node-express
export BRANCH=master
"

# verificacion de parametros
if [[ -z ${APP_ENTRY_POINT} || -z ${APP_FOLDER} || -z ${CLONE_URL} ]]; then
    echo "${AYUDA}"
    exit 1
fi
if [[ -z ${BRANCH} ]]; then
    BRANCH=master
fi
echo "Arrancando instalacion de $APP_ENTRY_POINT@$BRANCH en $APP_FOLDER"

# configuracion para githubb por SSH
mkdir -p ~/.ssh
if [ ! -f ~/.ssh/config ]; then
    cat >~/.ssh/config <<SSH_CONFIG
Host github.com
StrictHostKeyChecking no
UserKnownHostsFile=/dev/null
SSH_CONFIG
fi

# instalacion de curl y git en funcion de la distribucion
if [[ -e /etc/redhat-release || -e /etc/system-release ]]; then
    yum -y check-update
    yum install git curl -y
else
    apt-get -y update
    apt-get install git curl -y
fi

# metodo alternativo de deteccion de distribucion
# instalacion de nodeJS y npm
if [[ -x /usr/bin/yum ]]; then
    OS=$(rpm -q --whatprovides redhat-release | cut -d"-" -f1)
    case $OS in
    system)
        yum -y install openssl-devel nodejs npm --enablerepo=epel
        ;;
    *)
        yum -y install epel-release
        yum -y install openssl-devel nodejs npm
        ;;
    esac
else
    if [[ ! -z $(uname -a | grep -i ubuntu) ]]; then curl -sL https://deb.nodesource.com/setup_12.x | sudo bash -; fi
    apt-get -y install nodejs
fi

# herramienta para ejecutar una script indefinidamente
# la aplicacion no sera un servicio, pero se comportara como tal
npm install forever -g

# descarga del codigo del respositorio
[[ -z "$APP_FOLDER" ]] && TARGET_DIRECTORY=$(basename "$CLONE_URL" .git) || TARGET_DIRECTORY=$APP_FOLDER
if [ ! -d $TARGET_DIRECTORY ]; then
    # clonado inicial
    if [ -z '$BRANCH' ]; then
        git clone $CLONE_URL $APP_FOLDER
    else
        git clone -b $BRANCH $CLONE_URL $TARGET_DIRECTORY
    fi
else
    # actualización de nuevos commits
    cd $TARGET_DIRECTORY
    git remote set-url origin {{ CLONE_URL }}
    git clean -f
    git fetch --all
    git fetch --tags
    if [ -z '$BRANCH' ]; then
        git reset --hard origin
    else
        git reset --hard "origin/$BRANCH"
    fi
    git pull origin $BRANCH
fi

# instalacion de las dependencias de nodeJS
pushd $APP_FOLDER
npm install
popd

# parada de los procesos de forever
PATH="$PATH:/usr/local/sbin:/usr/local/bin"
ps aux | grep $APP_FOLDER/$APP_ENTRY_POINT | grep -v grep -q
if [ $? -eq 0 ]; then
    forever stopall
fi

# arranque del script de entrada de la aplicacion
forever --minUptime 1000 --spinSleepTime 1000 \
    start $APP_FOLDER/$APP_ENTRY_POINT
