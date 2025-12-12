#!/bin/bash

# -e: Finaliza el script cuando hay error
# -x: Muestra el comando por pantalla
set -ex

# Cargamos las variables de entorno
source .env

# Actualiza los repositorios
apt update

# Actualizamos los paquetes
apt upgrade -y

# Instalamos MySQL Server
apt install mysql-server -y

# Configuramos MySQL para que escuche en la IP privada del backend
sed -i "s/127.0.0.1/$BACKEND_IP_PRIVADA/" /etc/mysql/mysql.conf.d/mysqld.cnf

# Reiniciamos MySQL para aplicar los cambios
systemctl restart mysql