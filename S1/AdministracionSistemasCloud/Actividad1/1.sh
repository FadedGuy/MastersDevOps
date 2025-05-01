#!/bin/bash
# Autor: Owen Puerta
# Verificamos si se pasó una ruta como argumento
if [-z "$1"]; then
    echo "Uso: $0 <ruta>"
    exit 1
fi

RUTA="$1"
# Realizamos la comprobación para poder determinar el tipo de archivo.
if [ -f "$RUTA" ]; then
    echo "Es un fichero normal."
elif [ -d "$RUTA" ]; then
    echo "Es un directorio."
else
    echo "Es otro tipo de fichero (por ejemplo, enlace, dispositivo, etc.)."
fi

# Ejecutamos el comando ls en formato largo
echo "Contenido:"
ls -l "$RUTA"
