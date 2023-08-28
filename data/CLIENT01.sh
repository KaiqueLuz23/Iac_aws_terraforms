#!/bin/bash
echo 'atualizando arquivos do ambiente app' &&
sed -i 's/old/new/g' /var/www/app/.env && #VALOR_AMBIENTE
sed -i 's/old/new/g' /var/www/app-nextjs/packages/web/.env.local && #VALOR_AMBIENTE
sudo sed -i 's/old/new/g' /etc/nginx/conf.d/app.conf && #VALOR_AMBIENTE
################################################################################
echo 'Reiniciando NGINX' &&
sudo service nginx restart &&
echo 'Limpando dados da instância redis1' &&
redis-cli -h dev-new.0001.use1.cache.amazonaws.com flushall&& # REDIS
################################################################################
echo 'Executando comandos Git' &&  
su ubuntu -c 'cd /var/www/app && git fetch origin && git checkout -- . && git checkout dev && git pull origin dev' &&
su ubuntu -c 'cd /var/www/app-nextjs && git stash && git fetch origin && git checkout -- . && git checkout master && git pull origin master' &&
echo 'Executando comandos PHP artisan' &&
su ubuntu -c 'cd /var/www/app && composer install' &&  
su ubuntu -c 'cd /var/www/app && php artisan migrate; php artisan db:seed; php artisan constants:update; php artisan constants:load; ' &&
su ubuntu -c 'cd /var/www/app-nextjs && . ~/.nvm/nvm.sh; nvm use 16; yarn install' &&
su ubuntu -c 'cd /var/www/app-nextjs && . ~/.nvm/nvm.sh; nvm use 16; pm2 kill; pm2 start yarn --name "app_nextjs" --interpreter bash -- web' &&
su ubuntu -c 'cd /var/www/app && . ~/.nvm/nvm.sh; nvm use 8; gulp' &&
echo '########################## ! AMBIENTE CRIADO ! ##########################'
exit 0
