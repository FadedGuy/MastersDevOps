#!/bin/bash
# Autor: Kevin Aceves

# Verifica si se pasó un parámetro
if [[ -z "$1" ]]; then
    echo "Uso: $0 <ruta_archivo>"
    exit 1
fi

# Verifica que el archivo exista
if [[ ! -f "$1" ]]; then
    echo "El archivo no existe o no es un archivo normal: $1"
    exit 1
fi

ARCHIVO="$1"
# Obtenemos la extensión y la convertimos a minusculas
EXTENSION="${ARCHIVO##*.}"
EXTENSION="${EXTENSION,,}"

# Comprueba si es JPG
if [[ "$EXTENSION" == "jpg" ]]; then
    DESTINO="$HOME/fotos/"

    # Crea la carpeta si no existe
    if [[ ! -d "$DESTINO" ]]; then
        mkdir -p "$DESTINO"
    fi

    # Copia el archivo
    cp "$ARCHIVO" "$DESTINO"
else
    echo "La extensión del archivo no es JPG."
fi
