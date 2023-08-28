#!/bin/bash
yum update -y
yum install -y sudo
sed -i 's/old/new/g' /var/www/app.com.br/models/db-settings.php
sed -i 's/old/new/g' /var/www/AsyncSearch/.env
sudo sed -i 's/old/new/g' /etc/php-fpm.d/www.conf
sudo sed -i 's/old/new/g' /etc/nginx/conf.d/app.com.br.conf 
sudo sed -i 's/old/new/g' /etc/nginx/conf.d/ws.app.com.br.conf 
sudo systemctl restart nginx.service