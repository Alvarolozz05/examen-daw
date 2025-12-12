#!/bin/bash
set -ex

source .env

# Creamos la base de datos de WordPress
mysql -u root -e "DROP DATABASE IF EXISTS $MOODLE_DB_NAME"
mysql -u root -e "CREATE DATABASE $MOODLE_DB_NAME"

# Creamos un Usuario y una Contraseña para la base de datos
mysql -u root -e "DROP USER IF EXISTS $MOODLE_DB_USER@'$IP_CLIENTE_MYSQL'"
mysql -u root -e "CREATE USER '$MOODLE_DB_USER'@'$IP_CLIENTE_MYSQL' IDENTIFIED BY '$MOODLE_DB_PASS'"

# Le damos privilegios al usuario sobre la base de datos
mysql -u root -e "GRANT ALL PRIVILEGES ON $MOODLE_DB_NAME.* TO $MOODLE_DB_USER@'$IP_CLIENTE_MYSQL'"