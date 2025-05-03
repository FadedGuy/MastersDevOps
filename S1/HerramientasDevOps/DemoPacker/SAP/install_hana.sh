#!/bin/bash

set -e

HANA_SID=${1}
HANA_INSTANCE_NUMBER=${2}
SYSTEM_PASSWORD=${3}

echo "Iniciando la instalación de SAP HANA con SID: ${HANA_SID} y número de instancia: ${HANA_INSTANCE_NUMBER}"

# Preparar los archivos de instalación
# Ejemplo:
# mkdir -p /hana/shared
# cp -r /tmp/hana_install/archives /hana/shared/

# Instalar SAP HANA (adaptar según tus necesidades)

/hana/shared/archives/hdbsetup --batch \
    --sid=${HANA_SID} \
    --number=${HANA_INSTANCE_NUMBER} \
    --password=${SYSTEM_PASSWORD} \
    --batch_report=/tmp/hana_install/hana_installation_report.txt

echo "Instalación de SAP HANA completada. Verificar /tmp/hana_install/hana_installation_report.txt"
