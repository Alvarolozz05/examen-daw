#!/bin/bash
set -ex

# Cargamos las variables de entorno
source .env

# Modificamos el parametro max_input_vars en php.ini
sed -i "s/;max_input_vars = 1000/max_input_vars = 5000/" /etc/php/8.*/apache2/php.ini
sed -i "s/;max_input_vars = 1000/max_input_vars = 5000/" /etc/php/8.*/cli/php.ini

# Eliminamos descargas previas de Moodle CLI
rm -f /tmp/v4.5.0.zip

# Descargamos Moodle CLI
wget https://github.com/moodle/moodle/archive/refs/tags/v4.5.0.zip -P /tmp

# Instalamos unzip
apt install unzip

# Eliminamos instalaciones previas de Moodle
rm -rf /tmp/moodle-4.5.0

# Descomprimos el archivo zip en el directorio raiz del servidor web
unzip /tmp/v4.5.0.zip -d /tmp

# Eliminamos instalaciones previas de Moodle
rm -rf /var/www/html/*

# Movemos los archivos descomprimidos al directorio raiz del servidor web
mv /tmp/moodle-4.5.0/* /var/www/html/

# Creamos el directorio moodledata
mkdir -p /var/www/moodledata/

# Modificamos el propietario y el grupo de /var/www/moodledata a www-data
chown -R www-data:www-data /var/www/moodledata

# Instalamos Moodle usando CLI
sudo -u www-data php /var/www/html/admin/cli/install.php \
    --lang=$MOODLE_LANG \
    --wwwroot=$MOODLE_WWWROOT \
    --dataroot=$MOODLE_DATAROOT \
    --dbtype=$MOODLE_DB_TYPE \
    --dbhost=$MOODLE_DB_HOST \
    --dbname=$MOODLE_DB_NAME \
    --dbuser=$MOODLE_DB_USER \
    --dbpass=$MOODLE_DB_PASS \
    --fullname="$MOODLE_FULLNAME" \
    --shortname="$MOODLE_SHORTNAME" \
    --summary="$MOODLE_SUMMARY" \
    --adminuser=$MOODLE_ADMIN_USER \
    --adminpass=$MOODLE_ADMIN_PASS \
    --adminemail=$MOODLE_ADMIN_EMAIL \
    --non-interactive \
    --agree-license

# Configuramos una URL personalizada para la página de login
sudo -u www-data php /var/www/html/admin/cli/set_config.php --name=loginurl --value="$URL_HIDE_LOGIN"

# Copiamos el archivo htaccess para reescritura de endpoints
cp ../htaccess/.htaccess /var/www/html/.htaccess

# Modificamos el propietario y el grupo de /var/www/html a www-data
chown -R www-data:www-data /var/www/html