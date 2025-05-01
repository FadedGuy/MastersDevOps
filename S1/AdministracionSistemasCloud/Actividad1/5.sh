#!/bin/bash
# Autor: Sebastian Serrano

DATE=$(date +%Y%m%d)
echo "Fecha actual: $DATE"

# Se crean 10 archivos con extensiones diferentes para la prueba
EXTENSIONES=("jpg" "png" "gif" "jpeg")
for i in $(seq 1 10); do
    CICLO=$(((i - 1) % ${#EXTENSIONES[@]}))

    # Se escoge una extensión random (Se controla secuencia para que siempre seleccione dentro de la longitud de opciones de extensión posibles)
    EXTENSION=${EXTENSIONES[$CICLO]}

    # Crea el archivo vacio con su extension
    touch "image${i}.${EXTENSION}"
done

echo "Se han creado 10 archivos vacios con extension "jpg" "png" "gif" en el directorio actual."

# Se procede a buscar los archivos con la extensión "jpg" para cambiar el nombre con el formato de fecha.
find "./" -type f -name "*.jpg" | while read FILE; do
    # Obtener el nombre base del archivo
    BASENAME=$(basename "$FILE")

    # Comprobar si el nombre del archivo ya comienza con la fecha (DATE)
    if [[ ! "$BASENAME" =~ ^$DATE ]]; then
        # Si no tiene el prefijo de fecha, renombramos el archivo
        echo "Renombrando: $FILE"
        mv -v "$FILE" "./$DATE-$BASENAME"
    else
        # Si ya tiene el prefijo, no hacer nada
        echo "El archivo ya tiene el prefijo de fecha: $FILE"
    fi
done
