#!/bin/bash
set -ex

source .env

# Creamos la base de datos de WordPress
mysql -u root -e "DROP DATABASE IF EXISTS $DB_NAME"
mysql -u root -e "CREATE DATABASE $DB_NAME"

# Creamos un Usuario y una Contraseña para la base de datos
mysql -u root -e "DROP USER IF EXISTS $DB_USER@'$IP_CLIENTE_MYSQL'"
mysql -u root -e "CREATE USER '$DB_USER'@'$IP_CLIENTE_MYSQL' IDENTIFIED BY '$DB_PASSWORD'"

# Le damos privilegios al usuario sobre la base de datos
mysql -u root -e "GRANT ALL PRIVILEGES ON $DB_NAME.* TO $DB_USER@'$IP_CLIENTE_MYSQL'"