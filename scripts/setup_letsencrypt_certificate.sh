#!/bin/bash
set -ex

source .env

cp ../conf/000-default.conf /etc/apache2/sites-available

sed -i "s/PUT_YOUR_CERTBOT_DOMAIN_HERE/$CERTBOT_DOMAIN/" /etc/apache2/sites-available/000-default.conf

sudo snap install core
sudo snap refresh core

sudo apt remove certbot -y
sudo snap install --classic certbot

sudo ln -fs /snap/bin/certbot /usr/bin/certbot

certbot --apache -m $CERTBOT_CORREO --agree-tos --no-eff-email -d $CERTBOT_DOMAIN --non-interactive