# Actividad1

## Creacion de imagenes

Los siguientes ejemplos son desde el directorio de cada imagen
```bash
docker build -t my-nginx .
docker build -t my-wordpress .
```

## Puesta en marcha (con docker-compose)
```bash
# Para ejecutarlo creando una nueva build de las imagenes
docker compose up --build

# Para ejecutarlo utilizando las imagenes desde Docker Hub
docker compose up

# Para apagarlo
docker compose down

# Para apagarlo y borrar los volumenes tambien
docker compose down -v
```

## Puesta en marcha (sin docker-compose)

```bash
# Creamos una red sobre la cual se comunicaran los contenedores
docker network create wp-network

# Creamos un volumen donde mysql almacenara la informacion
docker volume create wp-db-data

# Levantar la db con un volumen
docker run -d --name wp-db --network wp-network -v wp-db-data:/var/lib/mysql -e MYSQL_ROOT_PASSWORD=rootpassword -e MYSQL_DATABASE=wordpress -e MYSQL_USER=wpuser -e MYSQL_PASSWORD=wppassword mysql:8.1

# Mapea el puerto 8080 del host al 80 del contenedor
docker run -d --name wp-nginx -p 8080:80 --network wp-network my-nginx

# El volumen es para persistir la informacion al host
docker run -d --name wp-php --network wp-network my-wordpress
```
