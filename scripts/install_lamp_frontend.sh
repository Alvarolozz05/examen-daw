#!/bin/bash

# -e: Finaliza el script cuando hay error
# -x: Muestra el comando por pantalla
set -ex

# Actualiza los repositorios
apt update

# Actualizamos los paquetes
apt upgrade -y

# Instalamos el servidor web apache
apt install apache2 -y

# Instalamos PHP y todos los paquetes y extensiones necesarias
apt install -y php libapache2-mod-php php-mysql php-xml php-mbstring php-curl php-zip php-gd php-intl php-soap

# Modificamos el parametro max_input_vars en php.ini
sed -i "s/;max_input_vars = 1000/max_input_vars = 5000/" /etc/php/8.*/apache2/php.ini
sed -i "s/;max_input_vars = 1000/max_input_vars = 5000/" /etc/php/8.*/cli/php.ini

# Copiamos el archivo de configuracion de apache
cp ../conf/000-default.conf /etc/apache2/sites-available

# Habilitamos el módulo rewrite
a2enmod rewrite

# Reiniciamos el servidor de Apache
systemctl restart apache2

# Copiamos nuestro archivo de prueba PHP a /var/www/html
cp ../php/index.php /var/www/html

# Modificamos los permisos de la carpeta html
chown -R www-data:www-data /var/www/html