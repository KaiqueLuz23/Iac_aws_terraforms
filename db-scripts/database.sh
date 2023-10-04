#!/bin/bash
# Configurações do banco de dados
DB_HOST="internal.app.com"
DB_USER="root"
DB_PASSROOT="xxxx"



##################################################################################################
# Pedir o nome do APP
echo 'Exemplo nome Squad: "sre", "alcateia"'
read -p "Nome da squad? " SQUAD
echo ''
echo "Escolha uma ação:"
echo "1. Criar BD APP1 e USER teste_squad"
echo "2. Criar BD APP2 e GRANT USER teste_squad à BD APP2"
echo "3. DUMP para BD APP2"
echo "4. DUMP para BD APP1"
echo ''
read -p "Digite o número da ação desejada: " ACTION
echo ''
##################################################################################################
if [ "$ACTION" == "1" ]; then
    # Configurações do banco de dados e usuário com base na squad
    DB_NAME="APP1_${SQUAD}"
    DB_NAME_BT="APP1_${SQUAD}_bt"
    DB_NAME_CACHE="APP1_${SQUAD}_cache"
    DB_NAME_META="APP1_${SQUAD}_meta"
    DB_USER_NEW="teste_${SQUAD}"
    DB_PASS_NEW="xxxx"


    # Comandos SQL para criação do banco de dados e usuário
    SQL_CREATE_DB="CREATE DATABASE IF NOT EXISTS $DB_NAME;"                                     # DB=APP1_sre
    SQL_CREATE_DB_BT="CREATE DATABASE IF NOT EXISTS $DB_NAME_BT;"                               # DB=APP1_sre_bt
    SQL_CREATE_DB_CACHE="CREATE DATABASE IF NOT EXISTS $DB_NAME_CACHE;"                         # DB=APP1_sre_cache
    SQL_CREATE_DB_META="CREATE DATABASE IF NOT EXISTS $DB_NAME_META;"                           # DB=APP1_sre_meta
    SQL_CREATE_USER="CREATE USER '$DB_USER_NEW'@'$DB_HOST' IDENTIFIED BY '$DB_PASS_NEW';"       # CREATE USER DB
    SQL_GRANT_PRIVILEGES="GRANT ALL PRIVILEGES ON $DB_NAME.* TO '$DB_USER_NEW'@'%';"            # GRANT USER 123_sre
    SQL_GRANT_PRIVILEGES_BT="GRANT ALL PRIVILEGES ON $DB_NAME_BT.* TO '$DB_USER_NEW'@'%';"         # GRANT USER 123_sre_bt
    SQL_GRANT_PRIVILEGES_CACHE="GRANT ALL PRIVILEGES ON $DB_NAME_CACHE.* TO '$DB_USER_NEW'@'%';"      # GRANT USER 123_sre_cache
    SQL_GRANT_PRIVILEGES_META="GRANT ALL PRIVILEGES ON $DB_NAME_META.* TO '$DB_USER_NEW'@'%';"       # GRANT USER_sre_meta
    SQL_FLUSH="FLUSH PRIVILEGES;"
    # Executar comandos SQL usando o cliente MySQL
    mysql -h $DB_HOST -u $DB_USER -p$DB_PASSROOT -e "$SQL_CREATE_DB $SQL_CREATE_DB_BT $SQL_CREATE_DB_CACHE $SQL_CREATE_DB_META $SQL_CREATE_USER $SQL_GRANT_PRIVILEGES $SQL_GRANT_PRIVILEGES_META  $SQL_GRANT_PRIVILEGES_CACHE $SQL_GRANT_PRIVILEGES_BT $SQL_FLUSH"
    if [ $? -eq 0 ]; then
        echo "Banco de dados '$DB_NAME' e usuário '$DB_USER_NEW' criados com sucesso."
    else
        echo "Ocorreu um erro ao criar o banco de dados e usuário."
    fi
elif [ "$ACTION" == "2" ]; then
    DB_NAME_BF="APP2_${SQUAD}"
    EXISTING_DB_USER="teste_${SQUAD}"
    SQL_CREATE_DB_BF="CREATE DATABASE IF NOT EXISTS $DB_NAME_BF;"
    # Comando SQL para atribuir usuário existente ao banco de dados
    SQL_ASSIGN_USER="GRANT ALL PRIVILEGES ON $DB_NAME_BF.* TO '$EXISTING_DB_USER'@'%';"
    SQL_FLUSH="FLUSH PRIVILEGES;"
    # Executar comandos SQL usando o cliente MySQL
    mysql -h $DB_HOST -u $DB_USER -p$DB_PASSROOT -e "$SQL_CREATE_DB_BF $SQL_ASSIGN_USER $SQL_FLUSH"
    if [ $? -eq 0 ]; then
        echo "Usuário  atribuído ao banco de dados com sucesso."
    else
        echo "Ocorreu um erro ao atribuir o usuário ao banco de dados."
    fi
elif [ "$ACTION" == "3" ]; then
    mysqldump --ssl-mode=DISABLE --column-statistics=0 --no-tablespaces -h $DB_HOST -u $DB_USER -p"$DB_PASSROOT" APP2_sre | mysql -h $DB_HOST -u $DB_USER -p"$DB_PASSROOT" APP2_$SQUAD
    # Comando SQL para realizar o update
    SQL_QUERY_BF="UPDATE APP2_$SQUAD.configuration SET `value` = REPLACE(`value`, "sre", "$SQUAD") WHERE `value` LIKE "%sre%";"
    # # Executa o comando SQL
    mysql -h "$DB_HOST" -u "$DB_USER" -p"$DB_PASS" "$DB_NAME" -e "$SQL_QUERY_BF"
    if [ $? -eq 0 ]; then
        echo "Dump realizado com sucesso."
    else
        echo "Ocorreu um erro"
    fi
elif [ "$ACTION" == "4" ]; then
    mysqldump --ssl-mode=DISABLE --column-statistics=0 --no-tablespaces --ignore-table=XXXXXX  -h $DB_HOST -u $DB_USER -p"$DB_PASSROOT" APP1_flaps  | mysql -h $DB_HOST -u $DB_USER -p"$DB_PASSROOT" APP1_$SQUAD
    mysqldump --ssl-mode=DISABLE --column-statistics=0 --no-tablespaces --ignore-table=XXXXXX  -h $DB_HOST -u $DB_USER -p"$DB_PASSROOT" APP1_flaps_bt  | mysql -h $DB_HOST -u $DB_USER -p"$DB_PASSROOT" APP1_${SQUAD}_bt
    mysqldump --ssl-mode=DISABLE --column-statistics=0 --no-tablespaces --ignore-table=XXXXXX  -h $DB_HOST -u $DB_USER -p"$DB_PASSROOT" APP1_flaps_cache  | mysql -h $DB_HOST -u $DB_USER -p"$DB_PASSROOT" APP1_${SQUAD}_cache
    mysqldump --ssl-mode=DISABLE --column-statistics=0 --no-tablespaces --ignore-table=XXXXXX  -h $DB_HOST -u $DB_USER -p"$DB_PASSROOT" APP1_flaps_meta  | mysql -h $DB_HOST -u $DB_USER -p"$DB_PASSROOT" APP1_${SQUAD}_meta
    # Comando SQL para realizar o update
    SQL_QUERY_123="UPDATE APP1_$SQUAD.configs SET `value` = REPLACE(`value`, "rudder", "$SQUAD") WHERE `value` LIKE "%rudder%";"
    # # Executa o comando SQL
    mysql -h "$DB_HOST" -u "$DB_USER" -p"$DB_PASS" "$DB_NAME" -e "$SQL_QUERY_123"
    if [ $? -eq 0 ]; then
        echo "Dump realizado com sucesso."
    else
        echo "Ocorreu um erro"
    fi    
else
    echo "Opção inválida. Saindo do script."
fi
